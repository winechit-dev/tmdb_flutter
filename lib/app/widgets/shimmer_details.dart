import 'package:flutter/material.dart';
import 'package:tmdb_flutter/app/widgets/shimmer_loading.dart';

class ShimmerDetails extends StatelessWidget {
  const ShimmerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          const ShimmerLoading(
            height: 320,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          const SizedBox(height: 24),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerLoading(height: 28, width: 220),
          ),
          const SizedBox(height: 16),
          // Info row (runtime, release date)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ShimmerLoading(height: 20, width: 60),
                SizedBox(width: 24),
                ShimmerLoading(height: 20, width: 80),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Overview
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerLoading(),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerLoading(width: 280),
          ),
          const SizedBox(height: 24),
          // Cast title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerLoading(height: 20, width: 80),
          ),
          const SizedBox(height: 12),
          // Cast list
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(left: 16),
                child: ShimmerLoading(
                  height: 70,
                  width: 70,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
