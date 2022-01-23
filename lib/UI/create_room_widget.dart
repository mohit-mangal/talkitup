import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkitup/UI/bg_gradient.dart';

class CreateRoomWidget extends StatefulWidget {
  final Function(String title, MemoryImage? image) createRoom;
  const CreateRoomWidget(this.createRoom, {Key? key}) : super(key: key);
  @override
  State<CreateRoomWidget> createState() => _CreateRoomWidgetState();
}

class _CreateRoomWidgetState extends State<CreateRoomWidget> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  MemoryImage? image;

  void _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        image = MemoryImage(await picked.readAsBytes());
      }
    } catch (e) {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      child: BgGradient(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.6 * 9 / 16,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: image == null
                          ? InkWell(
                              onTap: _pickImage,
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_sharp,
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                InkWell(
                                  onTap: _pickImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(image: image!),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        val ??= '';
                        if (val.trim().length < 3) {
                          return 'Atleast be 3 characters :}';
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  if (_formKey.currentState?.validate() == true) {
                    widget.createRoom(_titleController.text, image);
                  }
                },
                child: Card(
                  color: Colors.redAccent,
                  shadowColor: Colors.yellow,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.greenAccent,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
