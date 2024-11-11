/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-20-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class GenerateRandomTime {
    public static Time generateRandomTimeInRange(Time fromTime, Time toTime) {
        if (fromTime == null || toTime == null || fromTime > toTime) {
          return null;
        } else if (fromTime == toTime) {
          return fromTime;
        } else {
          try {
            Long startSeconds = fromTime.hour() * 3600 + fromTime.minute() * 60 + fromTime.second();
            Long endSeconds = toTime.hour() * 3600 + toTime.minute() * 60 + toTime.second();
            Long totalSeconds = endSeconds - startSeconds;
            Long randomSeconds = Math.round(Math.random() * totalSeconds);
            Long randomTimeInSeconds = startSeconds + randomSeconds;
            Integer hours = (Integer) (randomTimeInSeconds / 3600);
            Integer minutes = (Integer) (Math.mod(randomTimeInSeconds, 3600) / 60);
            Integer seconds = (Integer) (Math.mod(randomTimeInSeconds, 60));
            return Time.newInstance(hours, minutes, seconds, 0);
          } catch (Exception e) {
            System.debug('Error when generating random time: ' + e.getMessage());
            return null;
          }
        }
      }
}