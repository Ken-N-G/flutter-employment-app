enum ScreenRoutes {
  signIn("/signIn"),
  register("/register"),
  main("/navigation"),
  applicationDetails("/applicationDetails"),
  interviewDetails("/interviewDetails"),
  settings("/settings"),
  feedbackList("/feedbackList"),
  postingDetails("/postingDetails"),
  editProfile("/editProfile"),
  options("/options"),
  editProfileTextSection("/editProfileTextSection"),
  editVisionAndMissionSection("/editVisionAndMissionSection"),
  solicitorDetails("/solicitorDetails"),
  reportFeedback("/reportFeedback"),
  reportProfile("/reportProfile"),
  applications("/applications"),
  createInterview("/createInterview"),
  notifications("/notifications"),
  resumePreview("/resumePreview"),
  createJob("/createJob");
  final String route;
  const ScreenRoutes(this.route);
}