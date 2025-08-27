from enum import Enum

class ResponseSignal(Enum):
    FILE_TYPE_NOT_SUPPORTED = "file type not supported"
    FILE_SIZE_EXCEEDED = "file size exceeded"
    FILE_UPLOADED_SUCCESSFULLY = "file uploaded successfully"
    FILE_UPLOAD_FAILED = "file upload failed"
    FILE_VALIDATION_SUCCESS = "file validation success"
    PROCESSING_FAILED = "processing failed"
    PROCESSING_SUCCESS = "processing success"