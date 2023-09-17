class UserSearchResponseModel {
  UserSearchResponseDataModel search;

  UserSearchResponseModel({
    required this.search,
  });

  factory UserSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      UserSearchResponseModel(
        search: UserSearchResponseDataModel.fromJson(json["search"]),
      );
}

class UserSearchResponseDataModel {
  List<UserSearchModel> searchResults;
  PageInfo pageInfo;

  UserSearchResponseDataModel({
    required this.searchResults,
    required this.pageInfo,
  });

  factory UserSearchResponseDataModel.fromJson(Map<String, dynamic> json) =>
      UserSearchResponseDataModel(
        searchResults: List<UserSearchModel>.from(
            json["nodes"].map((x) => UserSearchModel.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
      );
}

class UserSearchModel {
  String? bio;
  String id;
  String? name;
  String avatarUrl;

  UserSearchModel({
    required this.bio,
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) =>
      UserSearchModel(
        bio: json["bio"],
        id: json["id"],
        name: json["name"],
        avatarUrl: json["avatarUrl"],
      );
}

class PageInfo {
  String? endCursor;
  bool hasNextPage;

  PageInfo({
    required this.endCursor,
    required this.hasNextPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        endCursor: json["endCursor"],
        hasNextPage: json["hasNextPage"],
      );
}
