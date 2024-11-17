import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/general_widgets/errorTextButton.dart';
import 'package:intl/intl.dart';

class FeedbackItem extends StatelessWidget {
  FeedbackItem({
    super.key,
    required this.username,
    required this.profileUrl,
    required this.endorseText,
    required this.dislikeText,
    required this.feedback,
    required this.datePosted,
    required this.onEndorseTap,
    required this.onDislikeTap,
    required this.onReportTap,
  });

  final String username;
  final String profileUrl;
  final String endorseText;
  final String dislikeText;
  final String feedback;
  final DateTime datePosted;
  final Function()? onEndorseTap;
  final Function()? onDislikeTap;
  final Function() onReportTap;


  Widget _setProfilePicture(String? profileUrl, BuildContext context) {
    if (profileUrl != null && profileUrl.isNotEmpty) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: 32,
        height: 32,
        child: Image.network(
          profileUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Ink(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle
              ),
              child: Icon(
                Icons.person_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            );
          },
        ),
      );
    } else {
      return Ink(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle
        ),
        child: Icon(
          Icons.person_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      );
    }
  }

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _setProfilePicture(profileUrl, context),
            
                const SizedBox(width: 10,),
            
                Text(
                  username,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onEndorseTap,
                  child: Ink(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_up_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                
                        const SizedBox(width: 5,),
                
                        Text(
                          endorseText,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10,),

                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onDislikeTap,
                  child: Ink(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 110, 0),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_down_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),

                        const SizedBox(width: 5,),

                        Text(
                          dislikeText,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),

        const SizedBox(height: 10,),

        Text(
          feedback,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Posted at ${formatter.format(datePosted)}",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            ErrorTextButton(
              label: "Report", 
              onTap: onReportTap
            ),
          ],
        ),
      ],
    );
  }
}