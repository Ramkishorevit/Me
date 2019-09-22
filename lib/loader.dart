import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loader extends StatefulWidget {
  @override
  LoaderAnimationWidgetState createState() => LoaderAnimationWidgetState();
}

class LoaderAnimationWidgetState extends State<Loader>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;
  bool appState = false;
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    _controller.forward();
    if(!appState) {
      return _triggerLoader;
    }
    return _loadView;
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ))..addStatusListener(handler);
  }

  void handler(status) {
    if (status == AnimationStatus.completed) {
      _animation.removeStatusListener(handler);
      _controller.reset();
      _animation = Tween(begin: 0.0, end: 11.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ))..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              appState = true;
            });
          }
        });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get _loadView {
    List<ListItem> items = List<ListItem>();
    items.add(HeadingItem("Work"));
    items.add(MessageItem(Strings.workDescription));
    items.add(HeadingItem("Community"));
    items.add(MessageItem(Strings.communityDescription));
    items.add(HeadingItem("Blogs"));
    items.add(HeadingItem("Hackathon"));
    items.add(MessageItem(Strings.hacks));

    return Scaffold(
      body: Image(),

      ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = items[index];

          if (item is HeadingItem) {
            return ListTile(
              title: Text(
                item.heading,
                style: Theme.of(context).textTheme.headline,
              ),
            );
          } else if (item is MessageItem) {
            return ListTile(
              subtitle: Text(item.body),
            );
          }
        },
      ),
    );
  }

  Widget get _triggerLoader {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
              body:  Transform(
                transform:
                Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
                child: new Center(
                    child: CircularProgressIndicator(
                    )),
              )
          );
        });
  }
}

// The base class for the different types of items the list can contain.
abstract class ListItem {}

// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String body;

  MessageItem(this.body);
}

class Strings {
  static const String workDescription = "I work at Poynt as an Android Engineer (POS and Payments Platform). Previously I have worked and interned with Paytm (India's one of the biggest E-Commerce Payments Unicorn startup), Practo (One of the biggest Healthcare startup in India).";
  static const String communityDescription = "I was part of some of the open source non profit communities like Google Developers Group (GDG VIT), Node School, I also used to contribute to Picasso (Powerful image caaching and loading library) and Zulip (A powerful open source team chat) android app.";
  static const String blogInfo = "Check out my medium profile.";
  static const String hacks = "I have participated and won a lot of interesting hackathons from Goethe german coding culture hackathon to TCS digital Hackathon'16. Most recently we came second in Practo sandbox '17 hack. Check out our blog on how we built this project.";
}

