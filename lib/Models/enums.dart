enum AudienceStatus { Blocked, Participant, ActiveJoinRequest }

enum ClubStatus { Waiting, Live, Concluded }

String enumToString<T>(T status) => status.toString().split('.')[1];
