import 'package:chandoiqua/data/providers/favorite_provider.dart';
import 'package:chandoiqua/presentation/features/detail_screen_discovery/detail_screen_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../data/providers/location_provider.dart';
import '../../../../data/repositories/discovery_repository.dart';
import '../../favorite_screen/favorite_screen.dart';
import '../../sign_in/sign_in_screen.dart';
import 'error_text.dart';
import 'favorite_icon.dart';
import 'loader.dart';

class ListViewLocation extends ConsumerWidget {
  const ListViewLocation({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteProvider);
    final locations = ref.watch(getLocationsProvider);
    final DiscoveryController discoveryController =
        Get.put(DiscoveryController());
    return Container(
      color: Colors.white,
      child: locations.when(
          data: (data) {
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DetailPage(),
                                            settings: RouteSettings(
                                                arguments: data[index]),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  data[index].image!,
                                                  fit: BoxFit.cover,
                                                  height: 230,
                                                  width: 210,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 170,
                                              top: 10,
                                              child: FavoriteIcon(
                                                isFavorite: isFavorite,
                                                onPressed: () {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (user == null) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LogIn()),
                                                      (route) => true,
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const FavoriteScreen()),
                                                    );
                                                  }
                                                  discoveryController
                                                      .addToFavorite(
                                                    title:
                                                        data[index].name ?? '',
                                                    image:
                                                        data[index].image ?? '',
                                                    price: data[index]
                                                        .price
                                                        .toString(),
                                                    location: data[index]
                                                            .provinceName ??
                                                        '',
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].name!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data[index].vote}/5',
                                                    ),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 35,
                                            ),
                                            // Text(
                                            //   'Từ ${data[index].price!.toStringAsFixed(0)}\$',
                                            //   style: const TextStyle(
                                            //     color: Colors.black,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontSize: 16.0,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
