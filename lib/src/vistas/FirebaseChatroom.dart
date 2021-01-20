import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:galibebe/service/ServiceAuth.dart';


class FirebaseChatroom extends StatefulWidget {
  const FirebaseChatroom({Key key}) : super(key: key);

  @override
  _FirebaseChatroomState createState() => _FirebaseChatroomState();
}

class _FirebaseChatroomState extends State<FirebaseChatroom> {
  DatabaseReference _firebaseMsgDbRef;

  FirebaseUser _user;
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc();
    this._firebaseMsgDbRef =
        kFirebaseDbRef.child('chats/${now.year}/${now.month}/${now.day}');
    kFirebaseAuth.currentUser().then(
          (user) => setState(() {
        this._user = user;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(

        actions: <Widget>[

          Container(
            padding: EdgeInsets.all(10),
            child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
              Navigator.pop(context);
            }),


          )

        ],


        leading: IconButton(
          icon:  CircleAvatar(
              backgroundColor: Colors.green,
              child:
              Text(_user.email.substring(0,4)),
              backgroundImage: NetworkImage(_user.photoUrl==null?"http://icons.iconarchive.com/icons/everaldo/crystal-clear/128/App-login-manager-icon.png":_user.photoUrl)),
          onPressed: () => _showNoteDialog(context),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(_user == null
              ? 'Chatting'
              : 'Bienvenido al tribu',style:TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
        ),
      ),
      body: Center(

        child: Column(

          children: <Widget>[
            _buildMessagesList(),
            Divider(height: 2.0),
            _buildComposeMsgRow()

          ],

        ),

widthFactor: 200,
      ),


    );

  }

  void _showNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nota'),
        content: Text('Hola.\n\n'
            'Este chat es publico '
            ' y el admin puede borrar todo el histroial en cualquier momento .\n\n'
            'para mandar mesajes tienes que logarte  '
            'en la app "GaliBebe" '),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  // Builds the list of chat messages.
  Widget _buildMessagesList() {
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          query: _firebaseMsgDbRef,
          sort: (a, b) => b.key.compareTo(a.key),
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (BuildContext ctx, DataSnapshot snapshot,
              Animation<double> animation, int idx) =>
              _messageFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  // Returns the UI of one message from a data snapshot.
  Widget _messageFromSnapshot(
      DataSnapshot snapshot, Animation<double> animation) {
    final String senderName = snapshot.value['senderName']==null?  this._user.email.substring(0,4): snapshot.value['senderName'];
    final String msgText = snapshot.value['text'] ?? '??';
    final sentTime = snapshot.value['timestamp'] ?? '<unknown timestamp>';
    final String senderPhotoUrl = snapshot.value['senderPhotoUrl']==null?"http://icons.iconarchive.com/icons/papirus-team/papirus-status/128/avatar-default-icon.png":snapshot.value['senderPhotoUrl'];
    final messageUI = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
textDirection:TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: senderPhotoUrl != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(senderPhotoUrl),
            )
                : CircleAvatar(
              child: Text(senderName[0]),
            ),
          ),
          Flexible(

            child: Column(


              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(senderName,style: TextStyle(color: Colors.lightBlue,fontStyle: FontStyle.italic),),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(sentTime).toString(),
                  style: Theme.of(context).textTheme.caption,
                softWrap: true,),
                Text(msgText,style: TextStyle(color: Colors.blueGrey,fontStyle: FontStyle.italic),),
             ],

            ),
          ),
        ],
      ),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: messageUI,
    );
  }

  // Builds the row for composing and sending message.
  Widget _buildComposeMsgRow() {
    return
      Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 6.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: null,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                controller: _textController,
                onChanged: (String text) =>
                    setState(() => _isComposing = text.length > 0),
                onSubmitted: _onTextMsgSubmitted,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: "Escribe tu mensaje"),
               // onEditingComplete: _save,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,color: Colors.cyan,),

              onPressed: _isComposing
                  ? () => _onTextMsgSubmitted(_textController.text)
                  : null,
            )
          ],
        ),
      );

    /* Container(

      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: TextField(
              keyboardType: TextInputType.multiline,
              // Setting maxLines=null makes the text field auto-expand when one
              // line is filled up.
              maxLines: null,
              maxLength: 200,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
              controller: _textController,
              onChanged: (String text) =>
                  setState(() => _isComposing = text.length > 0),
              onSubmitted: _onTextMsgSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () => _onTextMsgSubmitted(_textController.text)
                : null,
          ),
        ],
      ),
    );*/
  }

  // Triggered when text is submitted (send button pressed).
  Future<Null> _onTextMsgSubmitted(String text) async {
    // Make sure _user is not null.
    if (this._user == null) {
      this._user = await kFirebaseAuth.currentUser();
    }
    if (this._user == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Login required'),
          content: Text('Registarte para Enviar Mensajes.\n\n'
              '.  Gracias'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
      return;
    }
    // Clear input text field.
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Send message to firebase realtime database.
    _firebaseMsgDbRef.push().set({
      'senderId': this._user.uid,
      'senderName': this._user.displayName,
      'senderPhotoUrl': this._user.photoUrl,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

  }
}