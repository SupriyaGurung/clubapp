class ClubMember {
  String osis;
  String first_name;
  String last_name;
  String email;
  int itemNum;

  ClubMember(
      {this.osis = "",
      this.first_name = "",
      this.last_name = "",
      this.email = "",
      this.itemNum = 0});
}

class Clubs {
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

  Clubs(
      {this.name = "",
      this.meeting_day = "",
      this.room = "",
      this.advisor = "",
      this.ad_email = "",
      this.president = "",
      this.pr_osis = "",
      this.pr_email = "",
      this.vp = "",
      this.vp_osis = "",
      this.vp_email = "",
      this.secretary = "",
      this.se_osis = "",
      this.se_email = ""});
}
