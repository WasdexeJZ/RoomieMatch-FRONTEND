enum Personality { introverted, extroverted, ambivert }

extension PersonalityExtension on Personality {
  int get value {
    switch (this) {
      case Personality.introverted:
        return 0;
      case Personality.ambivert:
        return 1;
      case Personality.extroverted:
        return 2;
    }
  }
}

enum GuestsOver { often, sometimes, never }

extension GuestsOverExtension on GuestsOver {
  int get value {
    switch (this) {
      case GuestsOver.often:
        return 0;
      case GuestsOver.sometimes:
        return 1;
      case GuestsOver.never:
        return 2;
    }
  }
}

enum LoudNoise { yes, no }

extension LoudNoiseExtension on LoudNoise {
  int get value {
    switch (this) {
      case LoudNoise.yes:
        return 0;
      case LoudNoise.no:
        return 1;
    }
  }
}

enum Cleanliness { veryTidy, moderate, casual }

extension CleanlinessExtension on Cleanliness {
  int get value {
    switch (this) {
      case Cleanliness.veryTidy:
        return 0;
      case Cleanliness.moderate:
        return 1;
      case Cleanliness.casual:
        return 2;
    }
  }
}

enum Smoke { yes, no }

extension SmokeExtension on Smoke {
  int get value {
    switch (this) {
      case Smoke.yes:
        return 0;
      case Smoke.no:
        return 1;
    }
  }
}

enum GuestsFeeling { often, ocassionally, never }

extension GuestsFeelingExtension on GuestsFeeling {
  int get value {
    switch (this) {
      case GuestsFeeling.often:
        return 0;
      case GuestsFeeling.ocassionally:
        return 1;
      case GuestsFeeling.never:
        return 2;
    }
  }
}

enum Sociality { social, private, balanced }

extension SocialityExtension on Sociality {
  int get value {
    switch (this) {
      case Sociality.social:
        return 0;
      case Sociality.balanced:
        return 1;
      case Sociality.private:
        return 2;
    }
  }
}

enum LoudTv { yes, no }

extension LoudTvExtension on LoudTv {
  int get value {
    switch (this) {
      case LoudTv.yes:
        return 0;
      case LoudTv.no:
        return 1;
    }
  }
}

enum ContributeCleaning { veryImportant, somewhat, notImportant }

extension ContributeCleaningExtension on ContributeCleaning {
  int get value {
    switch (this) {
      case ContributeCleaning.notImportant:
        return 0;
      case ContributeCleaning.somewhat:
        return 1;
      case ContributeCleaning.veryImportant:
        return 2;
    }
  }
}

enum RoommateSmoke { yes, no, onlyOutside }

extension RoommateSmokeExtension on RoommateSmoke {
  int get value {
    switch (this) {
      case RoommateSmoke.yes:
        return 0;
      case RoommateSmoke.no:
        return 1;
      case RoommateSmoke.onlyOutside:
        return 2;
    }
  }
}
