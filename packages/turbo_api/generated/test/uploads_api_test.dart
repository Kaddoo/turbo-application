import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for UploadsApi
void main() {
  final instance = TurboApiGenerated().getUploadsApi();

  group(UploadsApi, () {
    // Get a signed URL to upload a file
    //
    // **Access:** any.  Files go straight to private object storage. Nothing here is ever publicly readable. Reference the returned uploadId in the next request.
    //
    //Future<UploadSlot> createUpload(UploadRequest uploadRequest) async
    test('test createUpload', () async {
      // TODO
    });

  });
}
