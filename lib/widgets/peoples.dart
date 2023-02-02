import 'package:api_people_flutter/providers/people_provider.dart';
import 'package:api_people_flutter/models/people_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeoplesWidget extends StatefulWidget {
  const PeoplesWidget({Key? key}) : super(key: key);

  @override
  State<PeoplesWidget> createState() => _PeopleWidgetState();
}

// à creuser
// https://github.com/archelangelo/flutter_lazy_listview

class _PeopleWidgetState extends State<PeoplesWidget> {
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
                    labelText: 'New People',
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
                    Provider.of<PeopleProvider>(context, listen: false)
                        .addPeople(newTaskController.text);
                    newTaskController.clear();
                  })
            ],
          ),
          FutureBuilder(
              future: Provider.of<PeopleProvider>(context, listen: false)
                  .getPeoples,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    return Consumer<PeopleProvider>(
                      child: Center(
                        heightFactor: MediaQuery.of(context).size.height * 0.03,
                        child: const Text(
                          'You have no tasks.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      builder: (ctx, peopleProvider, child) => peopleProvider
                              .items.isEmpty
                          ? child as Widget
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ListView.builder(
                                    itemCount: peopleProvider.items.length,
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
                                                peopleProvider.items[i].pseudo),
                                            trailing: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  PeopleItem p =
                                                      peopleProvider.items[i];
                                                  peopleProvider
                                                      .deletePeople(p.id);
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
