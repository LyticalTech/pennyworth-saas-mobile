class ConvoItem {
  String? convoId;
  String? fullName;
  String? lastMessage;
  String? avatarUrl;
  String? chattingWith;
  String? dateTime;

  ConvoItem({
    this.convoId,
    this.fullName,
    this.lastMessage,
    this.avatarUrl,
    this.chattingWith,
    this.dateTime,
  });

  factory ConvoItem.fromJson(Map data) {
    return ConvoItem(
      convoId: data['convo_id'],
      fullName: data['full_name'],
      lastMessage: data['last_message'],
      avatarUrl: data['avatar_url'],
      chattingWith: data['chatting_with'],
      dateTime: data['date'],
    );
  }

  @override
  String toString() {
    return "ConvoId: $convoId\nFull name: $fullName\nChatting with: $chattingWith";
  }
}
