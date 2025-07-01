import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_app/presentation/home/bloc/add_permission/add_permission_bloc.dart';
import 'package:flutter_absensi_app/presentation/home/pages/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';

class CutiPage extends StatefulWidget {
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  String? imagePath;
  late final TextEditingController reasonController;
  DateTimeRange? selectedDateRange;
  late final TextEditingController dateController;

  @override
  void initState() {
    reasonController = TextEditingController();
    dateController = TextEditingController();
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
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        dateController.text =
            '${formatDate(picked.start)} - ${formatDate(picked.end)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuti'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
                    GestureDetector(
            onTap: () => _selectDateRange(context),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: dateController,
                label: 'Tanggal Cuti',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
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
                  reasonController.clear();
                  dateController.clear();
                  setState(() {
                    imagePath = null;
                    selectedDateRange = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Submit Cuti success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                  context.pushReplacement(const MainPage());
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () {
                      if (selectedDateRange == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pilih tanggal cuti terlebih dahulu'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      }
                      final image =
                          imagePath != null ? XFile(imagePath!) : null;
                      for (var i = 0;
                          i <=
                              selectedDateRange!.end
                                  .difference(selectedDateRange!.start)
                                  .inDays;
                          i++) {
                        final date = selectedDateRange!.start
                            .add(Duration(days: i));
                        context.read<AddPermissionBloc>().add(
                              AddPermissionEvent.addPermission(
                                  type: 'cuti',
                                  date: formatDate(date),
                                  reason: reasonController.text,
                                  image: image!),
                            );
                      }
                    },
                    label: 'Kirim Permintaan Cuti',
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
    );
  }
}
