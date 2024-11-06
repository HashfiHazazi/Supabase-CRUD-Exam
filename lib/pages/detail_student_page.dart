import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:ph2_pwm_hashfi/main.dart';

class DetailStudentPage extends StatefulWidget {
  final String? nisnValue;
  const DetailStudentPage({super.key, required this.nisnValue});

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  late String? nisn;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nisnTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController classTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nisn = widget.nisnValue;
    if (nisn != null) {
      getDataStudent();
    }
  }

  Future<void> getDataStudent() async {
    try {
      final response = await supabase
          .from('tbl_siswa')
          .select()
          .eq('nisn', nisn!)
          .maybeSingle();

      if (response != null) {
        setState(() {
          nisnTextController.text = "${response['nisn']}";
          nameTextController.text = response['nama'] ?? '';
          classTextController.text = response['kelas'] ?? '';
        });
      } else {
        debugPrint('Student not found.');
      }
    } catch (error) {
      debugPrint('Error fetching student data: $error');
    }
  }

  Future<void> saveStudentData() async {
    if (formKey.currentState!.validate()) {
      final data = {
        'nisn': nisnTextController.text,
        'nama': nameTextController.text,
        'kelas': classTextController.text,
      };

      try {
        if (nisn == null) {
          await supabase.from('tbl_siswa').insert(data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Siswa baru berhasil di tambahkan!'),
              ),
            );
          }
        } else {
          await supabase.from('tbl_siswa').update(data).eq('nisn', nisn!);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Siswa berhasil di update!'),
              ),
            );
          }
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        debugPrint('Error saving student data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            MdiIcons.arrowLeft,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Detail Student Page",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 156,
                    child: Image.asset("assets/images/add_student.png"),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nisnTextController,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        hintText: "Input NISN..."),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "NISN Tidak Boleh Kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameTextController,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        hintText: "Input Nama..."),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama Tidak Boleh Kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: classTextController,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        hintText: "Input Kelas..."),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Kelas Tidak Boleh Kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: saveStudentData,
                      child: const Text(
                        "💾   SAVE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
