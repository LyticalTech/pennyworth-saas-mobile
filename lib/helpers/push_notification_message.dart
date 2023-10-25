class PushNotificationMessage {
  final String title;
  final String message;
  final String authorId;
  final String recipientId;

  PushNotificationMessage({
    required this.title,
    required this.message,
    required this.authorId,
    required this.recipientId,
  });
}
