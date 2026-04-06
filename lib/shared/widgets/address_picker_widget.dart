import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';

import '../../core/constants/api_keys.dart';
import '../../core/theme/app_theme.dart';
import '../../models/address_model.dart';

class AddressPickerWidget extends StatefulWidget {
  final AddressModel? currentAddress;
  final ValueChanged<AddressModel> onAddressChanged;

  const AddressPickerWidget({
    super.key,
    this.currentAddress,
    required this.onAddressChanged,
  });

  @override
  State<AddressPickerWidget> createState() => _AddressPickerWidgetState();
}

class _AddressPickerWidgetState extends State<AddressPickerWidget> {
  // 0 = GPS, 1 = Manual
  int _mode = 0;

  // GPS state
  bool _isLoadingGps = false;
  String? _gpsError;

  // Manual search state
  final _searchController = TextEditingController();
  List<MapBoxPlace> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  // Selected address (local copy, synced with parent)
  AddressModel? _address;

  late final GeoCodingApi _geoCoding;

  @override
  void initState() {
    super.initState();
    _address = widget.currentAddress;
    _geoCoding = GeoCodingApi(
      apiKey: ApiKeys.mapboxPublicToken,
      limit: 5,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── GPS ───────────────────────────────────────────────────────────────────

  Future<void> _fetchGpsAddress() async {
    setState(() {
      _isLoadingGps = true;
      _gpsError = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _gpsError = 'Location permission denied. Enter address manually.';
          _isLoadingGps = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // TODO(backend): Replace with Mapbox reverse geocode using GeoCoding.getAddress():
      // final result = await _geoCoding.getAddress((lat: position.latitude, long: position.longitude));
      final newAddress = AddressModel(
        formattedAddress:
            'Current Location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})',
        latitude: position.latitude,
        longitude: position.longitude,
        type: _address?.type ?? AddressType.house,
      );
      setState(() => _address = newAddress);
      widget.onAddressChanged(newAddress);
    } catch (e) {
      setState(() => _gpsError = 'Could not get location. Try manual entry.');
    }

    setState(() => _isLoadingGps = false);
  }

  // ── Mapbox autocomplete ───────────────────────────────────────────────────

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _isSearching = true);

    try {
      // ApiResponse<List<MapBoxPlace>> — ({List<MapBoxPlace>? success, FailureResponse? failure})
      final response = await _geoCoding.getPlaces(query);
      setState(() => _searchResults = response.success ?? []);
    } catch (_) {
      setState(() => _searchResults = []);
    }

    setState(() => _isSearching = false);
  }

  void _selectPlace(MapBoxPlace place) {
    // Location is a record type: ({double long, double lat})
    final lat = place.center?.lat ?? 0.0;
    final lng = place.center?.long ?? 0.0;
    final newAddress = AddressModel(
      formattedAddress: place.placeName ?? 'Unknown address',
      latitude: lat,
      longitude: lng,
      type: _address?.type ?? AddressType.house,
    );
    setState(() {
      _address = newAddress;
      _searchResults = [];
      _searchController.text = place.placeName ?? '';
    });
    widget.onAddressChanged(newAddress);
  }

  // ── Address type update ───────────────────────────────────────────────────

  void _setAddressType(AddressType type) {
    if (_address == null) return;
    final updated = _address!.copyWith(type: type);
    setState(() => _address = updated);
    widget.onAddressChanged(updated);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode toggle
        CupertinoSlidingSegmentedControl<int>(
          groupValue: _mode,
          backgroundColor: AppColors.surfaceElevated,
          thumbColor: AppColors.surface,
          children: const {
            0: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Use GPS'),
            ),
            1: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('Enter manually'),
            ),
          },
          onValueChanged: (v) {
            if (v != null) {
              setState(() {
                _mode = v;
                _gpsError = null;
                _searchResults = [];
              });
            }
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        // Mode content
        if (_mode == 0) _buildGpsSection() else _buildManualSection(),

        // Address type selector (shown once an address is selected)
        if (_address != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'ADDRESS TYPE',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: AddressType.values.map((type) {
              final isSelected = _address?.type == type;
              return GestureDetector(
                onTap: () => _setAddressType(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.accent : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    type.label,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? CupertinoColors.white
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildGpsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.md),
            onPressed: _isLoadingGps ? null : _fetchGpsAddress,
            child: _isLoadingGps
                ? const CupertinoActivityIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.location_fill,
                          size: 16, color: AppColors.accent),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Get Current Location',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_gpsError != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _gpsError!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
        if (_address != null && !_isLoadingGps && _gpsError == null) ...[
          const SizedBox(height: AppSpacing.md),
          _AddressDisplay(address: _address!),
        ],
      ],
    );
  }

  Widget _buildManualSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.divider),
          ),
          child: CupertinoTextField(
            controller: _searchController,
            placeholder: 'Search for your address...',
            onChanged: _onSearchChanged,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 14),
            decoration: null,
            placeholderStyle:
                AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            style: AppTextStyles.body,
            cursorColor: AppColors.accent,
            prefix: const Padding(
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Icon(CupertinoIcons.search,
                  size: 16, color: AppColors.textTertiary),
            ),
            suffix: _isSearching
                ? const Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md),
                    child: CupertinoActivityIndicator(),
                  )
                : null,
          ),
        ),

        // Autocomplete results
        if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 2),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: _searchResults.asMap().entries.map((entry) {
                final index = entry.key;
                final place = entry.value;
                return Column(
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      onPressed: () => _selectPlace(place),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.location,
                              size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              place.placeName ?? '',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < _searchResults.length - 1)
                      Container(height: 1, color: AppColors.divider),
                  ],
                );
              }).toList(),
            ),
          ),
        ],

        // Selected address display
        if (_address != null && _searchResults.isEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _AddressDisplay(address: _address!),
        ],
      ],
    );
  }
}

class _AddressDisplay extends StatelessWidget {
  final AddressModel address;
  const _AddressDisplay({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.checkmark_circle_fill,
              color: AppColors.accent, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              address.formattedAddress,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
