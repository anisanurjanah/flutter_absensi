import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_app/presentation/home/bloc/add_permission/add_permission_bloc.dart';
import 'package:flutter_absensi_app/presentation/home/pages/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/components/custom_date_picker.dart';
import '../../../core/core.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  String? imagePath;
  late final TextEditingController dateController;
  late final TextEditingController reasonController;

  final List<String> izinTypes = ['sakit', 'cuti', 'dinas luar'];
  String? selectedType;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateController = TextEditingController();
    reasonController = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      } else {
        debugPrint('No file selected.');
      }
    });
  }

  String formatDate(DateTime date) {
    // Gunakan DateFormat untuk mengatur format tanggal
    final dateFormatter = DateFormat('yyyy-MM-dd');
    // Kembalikan tanggal dalam format yang dinginkan
    return dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    try {
      final bloc = context.read<AddPermissionBloc>();
      print("AddPermissionBloc ditemukan: $bloc");
    } catch (e) {
      print("ERROR: Bloc tidak ditemukan: $e");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Jenis Izin',
              border: OutlineInputBorder(),
            ),
            value: selectedType,
            items: izinTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value;
              });
            },
            validator: (value) =>
            value == null ? 'Jenis izin harus dipilih' : null,
          ),
          const SizedBox(height: 16),
          CustomDatePicker(
            label: 'Tanggal',
            onDateSelected: (selectedDate) =>
                dateController.text = formatDate(selectedDate).toString(),
          ),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: reasonController,
            label: 'Keperluan',
            maxLines: 5,
          ),
          const SpaceHeight(26.0),
          Padding(
            padding: EdgeInsets.only(right: context.deviceWidth / 2),
            child: GestureDetector(
              onTap: _pickImage,
              child: imagePath == null
                  ? DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      radius: const Radius.circular(18.0),
                      dashPattern: const [8, 4],
                      child: Center(
                        child: SizedBox(
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Assets.icons.image.svg(),
                              const SpaceHeight(18.0),
                              const Text('Lampiran'),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      child: Image.file(
                        File(imagePath!),
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SpaceHeight(65.0),
          BlocConsumer<AddPermissionBloc, AddPermissionState>(
            listener: (context, state) {
              print("LISTENER DIPANGGIL dengan state: $state");
              state.maybeWhen(
                orElse: () {},
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
                success: () {
                  dateController.clear();
                  reasonController.clear();
                  setState(() {
                    imagePath = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Submit Izin success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                  context.pushReplacement(const MainPage());
                },
              );
            },
            builder: (context, state) {
              print("BUILDER DIPANGGIL dengan state: $state");
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () {
                      print("SUBMIT DITEKAN");
                      print("type: $selectedType");
                      print("date: ${dateController.text}");
                      print("reason: ${reasonController.text}");
                      print("image: $imagePath");

                      if (selectedType == null || dateController.text.isEmpty || reasonController.text.isEmpty) {
                        print("DATA BELUM LENGKAP");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Semua field wajib diisi"))
                        );
                        return;
                      }

                      final image = imagePath != null ? XFile(imagePath!) : null;
                      print("KIRIM EVENT BLOC");
                      context.read<AddPermissionBloc>().add(
                        AddPermissionEvent.addPermission(
                          type: selectedType!,
                          date: dateController.text,
                          reason: reasonController.text,
                          image: image!,
                        ),
                      );
                      // if (_formKey.currentState!.validate()) {
                      //   final image =
                      //       imagePath != null ? XFile(imagePath!) : null;
                      //   context.read<AddPermissionBloc>().add(
                      //     AddPermissionEvent.addPermission(
                      //         type: selectedType!,
                      //         date: dateController.text,
                      //         reason: reasonController.text,
                      //         image: image!),
                      //   );
                      // }
                    },
                    label: 'Kirim Permintaan',
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
      )
    );
  }
}
