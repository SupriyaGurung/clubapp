class ClubMember {
  String osis;
  String first_name;
  String last_name;
  String email;
  String password;
  // String role;
  // String clubs;
  //int itemNum;

  ClubMember(this.osis, this.first_name, this.last_name, this.email,
      this.password); //, this.itemNum);

  Map<String, dynamic> toMap() {
    return {
      'osis': osis,
      'first_name': first_name,
      'last_name': last_name,
      'email': email
    };
  }

  @override
  String toString() {
    return 'ClubMember{ osis: $osis, first_name: $first_name, last_name: $last_name, email: $email}';
  }
}

class Club {
  String name;
  String meeting_day;
  String room;
  String advisor;
  String ad_email;
  String president;
  String pr_osis;
  String pr_email;
  String vp;
  String vp_osis;
  String vp_email;
  String secretary;
  String se_osis;
  String se_email;

  Club(
      this.name,
      this.meeting_day,
      this.room,
      this.advisor,
      this.ad_email,
      this.president,
      this.pr_osis,
      this.pr_email,
      this.vp,
      this.vp_osis,
      this.vp_email,
      this.secretary,
      this.se_osis,
      this.se_email);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'meeting_day': meeting_day,
      'room': room,
      'advisor': advisor,
      'ad_email': ad_email,
      'president': president,
      'pr_osis': pr_osis,
      'pr_email': pr_email,
      'vp': vp,
      'vp_osis': vp_osis,
      'vp_email': vp_email,
      'secretary': secretary,
      'se_osis': se_osis,
      'se_email': se_email
    };
  }

  @override
  String toString() {
    return 'Club{ name: $name, meeting day: $meeting_day, room: $room, advisor: $advisor, president:$president}';
  }
}
