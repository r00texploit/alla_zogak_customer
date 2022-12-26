import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/address.dart';
import '../providers/address_provider.dart';

class UpdateAddressesWidget extends StatefulWidget {
  final bool pop;
  const UpdateAddressesWidget({Key? key, this.pop = false}) : super(key: key);
  @override
  State<UpdateAddressesWidget> createState() => _UpdateAddressesWidgetState();
}

class _UpdateAddressesWidgetState extends State<UpdateAddressesWidget> {
  bool loading = true;
  bool saving = false;
  Address? edit;
  late AddressBloc address;
  TextEditingController editing = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await address.loadData();
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    address = Provider.of<AddressBloc>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            height: 5,
            width: MediaQuery.of(context).size.width * .6,
          ),
        ),
        if (!loading)
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: address.addresses.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      address.delete(address.addresses[i].id);
                    });
                  },
                  key: UniqueKey(),
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.shade300,
                    ),
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: ListTile(
                      tileColor: Theme.of(context).primaryColor,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 110, 159, 243),
                        ),
                        onPressed: () {
                          setState(() {
                            edit = address.addresses[i];
                            editing.text = address.addresses[i].address;
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            address.delete(address.addresses[i].id);
                          });
                        },
                      ),
                      title: Text(
                        address.addresses[i].address,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                );
              },
            ),
          ),
        if (loading)
          const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: TextFormField(
            controller: editing,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == null ? "الرجاء إدخال عنوان" : null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: const Text("أدخل عنوان"),
              prefix: edit == null
                  ? const Text('')
                  : IconButton(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          edit = null;
                          editing.text = "";
                        });
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        if(saving)
         Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
        if(!saving)
        Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (editing.text.isNotEmpty && !saving) {
                      setState(() {
                        saving = true;
                      });
                      if (edit == null) {
                        await address.insert({'address': editing.text});
                        if (widget.pop) {
                          Navigator.pop(context);
                        }
                      } else {
                        await address
                            .update(edit!.id, {'address': editing.text});
                      }
                      setState(() {
                        editing.text = "";
                        saving = false;
                      });
                    }
                  },
                  icon: Icon(
                    edit == null ? Icons.save : Icons.edit,
                    size: 25,
                  ),
                  label: const Text("حفظ"),
                ),
              ),
      ],
    );
  }
}
