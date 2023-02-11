import 'package:api_people_flutter/providers/profile_provider.dart';
import 'package:api_people_flutter/models/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget({Key? key}) : super(key: key);

  @override
  State<ProfilesWidget> createState() => _ProfileWidgetState();
}

// à creuser
// https://github.com/archelangelo/flutter_lazy_listview

class _ProfileWidgetState extends State<ProfilesWidget> {
  TextEditingController newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: newTaskController,
                  decoration: const InputDecoration(
                    labelText: 'New Profile',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amberAccent),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.purple)),
                  child: const Text("Add"),
                  onPressed: () {
                    Provider.of<ProfileProvider>(context, listen: false)
                        .addProfile(newTaskController.text);
                    newTaskController.clear();
                  })
            ],
          ),
          FutureBuilder(
              future: Provider.of<ProfileProvider>(context, listen: false)
                  .getProfiles,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    return Consumer<ProfileProvider>(
                      child: Center(
                        heightFactor: MediaQuery.of(context).size.height * 0.03,
                        child: const Text(
                          'You have no tasks.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      builder: (ctx, profileProvider, child) => profileProvider
                              .items.isEmpty
                          ? child as Widget
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ListView.builder(
                                    itemCount: profileProvider.items.length,
                                    itemBuilder: (ctx, i) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: ListTile(
                                            tileColor: Colors.black12,
                                            leading: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.red,
                                            ),
                                            title: Text(
                                                profileProvider.items[i].name),
                                            trailing: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  ProfileItem p =
                                                      profileProvider.items[i];
                                                  profileProvider
                                                      .deleteProfile(p.id);
                                                }),
                                            onTap: () {},
                                          ),
                                        )),
                              ),
                            ),
                    );
                }

                return const Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }
}
