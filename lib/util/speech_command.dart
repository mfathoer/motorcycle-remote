class SpeechCommand {
  static const turnOnEngineCode = 1;
  static const turnOffEngineCode = 2;
  static const turnOnContactCode = 3;
  static const turnOffContactCode = 4;
  static const turnOnEmergencyCode = 5;
  static const turnOffEmergencyCode = 6;

  static void extractText(
      {required String rawText, required Function(int? commandCode) onResult}) {
    rawText = rawText.toLowerCase();
    // turn on engine
    if ((rawText.contains("turn on") ||
            rawText.contains("activate") ||
            rawText.contains("start") ||
            rawText.contains("star")) &&
        (rawText.contains("engine") || rawText.contains("machine"))) {
      onResult(turnOnEngineCode);
    }
    //turn off engine
    else if ((rawText.contains("turn off") ||
            rawText.contains("deactivate") ||
            rawText.contains("stop")) &&
        (rawText.contains("engine") || rawText.contains("machine"))) {
      onResult(turnOffEngineCode);
    }
    // turn on contact
    else if (((rawText.contains("turn on") || rawText.contains("activate")) &&
            rawText.contains("contact")) ||
        rawText.contains("engine pre-start")) {
      onResult(turnOnContactCode);
    }
    // turn off contact
    else if ((rawText.contains("turn off") ||
            rawText.contains("deactivate") ||
            rawText.contains("stop")) &&
        rawText.contains("contact")) {
      onResult(turnOffContactCode);
    }
    // turn on emergency mode
    else if ((rawText.contains("activate") || rawText.contains("turn on")) &&
        rawText.contains("emergency")) {
      onResult(turnOnEmergencyCode);
    }
    // turn off emergency mode
    else if ((rawText.contains("deactivate") || rawText.contains("turn off")) &&
        rawText.contains("emergency")) {
      onResult(turnOffEmergencyCode);
    } else {
      onResult(null);
    }
  }
}
