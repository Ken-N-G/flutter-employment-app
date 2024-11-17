import 'package:flutter/material.dart';

class SubPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubPageAppBar({
    super.key,
    required this.onBackTap,
    required this.title,
    this.actions
  });

  final Function() onBackTap;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: double.infinity,
      padding: EdgeInsets.only(
          left: 20, right: 20, top: MediaQuery.paddingOf(context).top),
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onBackTap,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 42,
                ),
              ),
                  
              const SizedBox(width: 10,),
                  
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          
          (actions != null) ?
            Row(
              children: actions!,
            ) :
            Container()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
