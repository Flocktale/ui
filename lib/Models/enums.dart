enum AudienceStatus { Blocked, Participant, ActiveJoinRequest }

String enumToString<T>(T status) => status.toString().split('.')[1];
