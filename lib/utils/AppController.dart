import 'package:http/http.dart' as http;

class AppController {
    static const String tag = 'AppController';

    // Singleton instance
    static final AppController _instance = AppController._internal();
    factory AppController() => _instance;
    AppController._internal();

    // HTTP client for network requests
    http.Client? _client;

    // Initialize the client
    void init() {
        _client ??= http.Client();
    }

    // Get the HTTP client
    http.Client getClient() {
        if (_client == null) {
            _client = http.Client();
        }
        return _client!;
    }

    // Add a request to the queue (simulated for async HTTP requests)
    Future<T> addToRequestQueue<T>(
        Future<T> Function(http.Client) request, {
            String? requestTag,
        }) async {
        try {
            final client = getClient();
            return await request(client);
        } catch (e) {
            // Simulate tagging for logging or debugging
            final tag = requestTag ?? AppController.tag;
            print('[$tag] Request failed: $e');
            rethrow;
        }
    }

    // Cancel pending requests (simulated, as http.Client doesn't support queue cancellation)
    void cancelPendingRequests(String tag) {
        // Note: http.Client doesn't maintain a request queue like Volley.
        // You can implement custom logic (e.g., using dio with CancelToken) if needed.
        print('[$tag] Cancelling pending requests (not implemented for http.Client)');
    }

    // Clean up resources
    void dispose() {
        _client?.close();
        _client = null;
    }
}