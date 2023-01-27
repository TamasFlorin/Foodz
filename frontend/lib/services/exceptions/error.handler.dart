String parseErrorResponse({int errorCode}) {
  switch (errorCode) {
    case 401:
    case 403:
    case 409:
      return 'Invalid login credentials!';
    default:
      return 'Ooops, something went wrong!';
  }
}
