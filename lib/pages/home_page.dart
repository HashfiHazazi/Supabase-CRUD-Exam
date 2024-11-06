import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ph2_pwm_hashfi/main.dart';
import 'package:ph2_pwm_hashfi/routers/route_pages.dart';
import 'package:ph2_pwm_hashfi/routers/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final siswaStream = supabase.from('tbl_siswa').stream(primaryKey: ['nisn']);

Future<void> deleteSiswa(String siswaNisn) async {
  await supabase.from('tbl_siswa').delete().eq('nisn', siswaNisn);
}

Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

class _HomePageState extends State<HomePage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  void dispose() {
    // disposing states
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const Icon(null),
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, RoutesName.signUp);
              }
            },
            icon: const Icon(
              MdiIcons.logout,
              color: Colors.red,
            ),
          )
        ],
        title: Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: siswaStream.asyncMap((snapshot) async {
          await Future.delayed(const Duration(seconds: 3));
          return snapshot;
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingBouncingGrid.square(
                borderColor: Theme.of(context).colorScheme.primary,
                size: 100,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            );
          }
          final resultData = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return Text(
                              'Welcome, ${snapshot.data}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text(
                              'Welcome, Guest',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Image.asset('assets/images/hello_emoji.png', height: 38)
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resultData[index]['nama'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Nisn: ${resultData[index]['nisn']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Kelas: ${resultData[index]['kelas']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesName.detail,
                                      arguments: DetailArguments(
                                        '${resultData[index]['nisn']}',
                                      ),
                                    );
                                  },
                                  icon: const Icon(MdiIcons.fileEditOutline),
                                ),
                                const SizedBox(width: 24),
                                IconButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title:
                                          'Anda yakin ingin menghapus data ini?',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        deleteSiswa(
                                            "${resultData[index]['nisn']}");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Data Siswa berhasil di hapus!'),
                                          ),
                                        );
                                      },
                                    ).show();
                                  },
                                  icon: const Icon(MdiIcons.deleteOutline),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: resultData.length,
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.detail);
        },
        child: const Icon(MdiIcons.notePlusOutline),
      ),
    );
  }
}
