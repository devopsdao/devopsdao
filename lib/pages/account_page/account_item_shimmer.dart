import 'package:dodao/blockchain/accounts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webthree/webthree.dart';
import '../../blockchain/classes.dart';

import '../../config/theme.dart';

class AccountItemShimmer extends StatelessWidget {
  final Account account;

  const AccountItemShimmer({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: DodaoTheme.of(context).borderRadius,
        color: DodaoTheme.of(context).taskBackgroundColor,
      ),
      child: Shimmer.fromColors(
        baseColor: DodaoTheme.of(context).shimmerBaseColor,
        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            border: DodaoTheme.of(context).borderGradient,
          ),
          child: ListTile(
            title: Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 100.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
