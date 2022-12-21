import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController search = TextEditingController();
  String? selectedValue;
  var icons;
  double progress = 0.0;
  String text = '';
  bool isGranted = false;
  String? fileName;
  List Content = [];
  List items = [
                "MP4",
                "MP3",
                "SRT",
                "PDF",
                "DOCX",
                "RAR",
                "ISO",
                "APK",
                "EXE"
                ];
  submit(String phrase)async{
    if(search.text == ""){
      showDialog(
        context: context, 
        builder: ((context) {
          return AlertDialog(
        title: Text("Error"),
        content: Text("Please Enter Search Phrase !"),
        actions: [
          ElevatedButton(onPressed: () =>  Navigator.pop(context) , child: Text("OK"))
        ],
      );
        }
        ));
    }else{
    Response req = await get(
      Uri.parse("https://filepursuit.p.rapidapi.com/?q=${phrase}&filetype=${selectedValue}"),
      headers: {
        'X-RapidAPI-Key': 'ed8aaedc7cmshf3c6a200313ac82p123172jsn50e430bde585',
        'X-RapidAPI-Host': 'filepursuit.p.rapidapi.com'
      }
      );
      var body = jsonDecode(req.body);
      setState(() {
        try{
          Content = body['files_found'];
          selectedValue == "MP4" ? 
                      icons = FontAwesomeIcons.video : 
                      selectedValue == "MP3" ? 
                      icons = FontAwesomeIcons.music: 
                      selectedValue == "SRT" ? 
                      icons = Icons.subtitles : 
                      selectedValue == "PDF" ? 
                      icons = FontAwesomeIcons.filePdf: 
                      selectedValue == "DOCX" ?
                      icons = FontAwesomeIcons.fileWord :
                      selectedValue == "RAR" ?
                      icons = FontAwesomeIcons.fileZipper:
                      selectedValue == "ISO" ?
                      icons = FontAwesomeIcons.compactDisc :
                      selectedValue == "APK" ?
                      icons = FontAwesomeIcons.android:
                      selectedValue == "EXE" ?
                      icons = FontAwesomeIcons.windows: Container();
        }catch(e){
          Content = [];
          text = "Files Not Found!";
        }
      });
  }
  }

   Launch(String url)async
   {
    if(await canLaunch(url) == true)
    {
      launch(url, enableJavaScript: true);
      showToast("Opening", position: StyledToastPosition(align: Alignment.bottomCenter), context: context, duration: Duration(seconds: 1),);
    }else{
      showToast("Something Went Wrong Try Again !", position: StyledToastPosition(align: Alignment.bottomCenter), context: context,);
    }
   }

   Color Colour(int index){
    if(index.isEven){
      
        return Color.fromARGB(114, 3, 46, 216);
      
    }
        return Color.fromARGB(113, 46, 46, 46);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Center(
                child: Text("File Pursuit", style: TextStyle(fontSize: 23,fontStyle: FontStyle.italic),),
                ),
                SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Search Phrase",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                          ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 23, 42, 249),
                          width: 2.0,
                          ),
                      ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "All Files",
                            style: TextStyle(overflow: TextOverflow.fade,color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    buttonElevation: 10,
                    dropdownMaxHeight: 150,
                    dropdownWidth: 150,
                    buttonWidth: 150,
                    icon: Icon(Icons.list, color: Color.fromARGB(164, 255, 255, 255),),
                    scrollbarThickness: 5,
                    dropdownScrollPadding: EdgeInsets.symmetric(vertical: 5),
                    buttonDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 33, 86, 243),
                      borderRadius: BorderRadius.circular(10)
                      ),
                      dropdownElevation: 5,
                      dropdownDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 33, 86, 243),
                      borderRadius: BorderRadius.circular(10)
                      ),
                    alignment: Alignment.center,
                    scrollbarAlwaysShow: true,
                    buttonPadding: EdgeInsets.symmetric(horizontal: 10),
                    items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ))
                    .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text("Search", style: TextStyle(fontStyle: FontStyle.italic),),
                onPressed: (){submit(search.text);},
              ),
               SizedBox(height: 20,),
               Content.isNotEmpty ?ListView.builder(
                controller: ScrollController(),
                padding: EdgeInsets.all(15),
                    shrinkWrap: true,
                    itemCount: Content.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            tileColor: Colour(index),
                            contentPadding: EdgeInsets.all(10),
                            onTap: (() async{
                              setState(() {
                                Launch(Content[index]['file_link']);
                              });
                            }),
                            leading: icons != null ? 
                            Icon(icons, color: Colors.white,)
                            : Container(),
                            title: Text("${Content[index]['file_name']}", style: TextStyle(color: Colors.white),),
                            subtitle: Text("${Content[index]['file_size']}", style: TextStyle(color: Colors.white),),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );
                    },
                  ):
                  Center(child:
                  Text("$text", style: TextStyle(fontSize: 20),),
               ),
            ],
          ),
        ),
      ),
    );
  }
}