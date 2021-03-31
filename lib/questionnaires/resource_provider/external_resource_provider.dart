import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Provide ValueSets based on a Uri.
/// Time-consuming prep operations need to go into init().
/// init() needs to be invoked before getValueSet can be used.
abstract class ExternalResourceProvider {
  Future<void> init();

  Resource? getResource(String uri);
}

class NestedExternalResourceProvider extends ExternalResourceProvider {
  final List<ExternalResourceProvider> externalResourceProviders;

  NestedExternalResourceProvider(this.externalResourceProviders);

  @override
  Future<void> init() async {
    for (final externalResourceProvider in externalResourceProviders) {
      await externalResourceProvider.init();
    }
  }

  @override
  Resource? getResource(String uri) {
    for (final externalResourceProvider in externalResourceProviders) {
      final resource = externalResourceProvider.getResource(uri);
      if (resource != null) {
        return resource;
      }
    }
    return null;
  }
}

class AssetResourceProvider extends ExternalResourceProvider {
  final Map<String, Resource> resources = {};
  final Map<String, String> assetMap;

  AssetResourceProvider(this.assetMap);

  @override
  Future<void> init() async {
    for (final assetEntry in assetMap.entries) {
      final resourceJsonString = await rootBundle.loadString(assetEntry.value);
      resources[assetEntry.key] = Resource.fromJson(
          json.decode(resourceJsonString) as Map<String, dynamic>);
    }
  }

  @override
  Resource? getResource(String uri) {
    return resources.containsKey(uri) ? resources[uri] : null;
  }
}