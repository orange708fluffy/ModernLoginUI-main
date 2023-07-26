import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modernlogintute/pages/data.dart';
import 'package:modernlogintute/pages/constants.dart';
import 'package:modernlogintute/pages/book_detail.dart';
import 'package:modernlogintute/pages/drawer.dart';
import 'package:modernlogintute/pages/login_page.dart';
import 'package:modernlogintute/pages/profile_page.dart';

class Bookstore extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BookstoreState createState() => _BookstoreState();
}

class _BookstoreState extends State<Bookstore> {

  List<Filter> filters = getFilterList();
  late Filter selectedFilter;

  List<NavigationItem> navigationItems = getNavigationItemList();
  late NavigationItem selectedItem;

  List<Book> books = getBookList();
  List<Author> authors = getAuthorList();

  void _goToProfilePage() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()),
  );
}
  void signOut () {
    FirebaseAuth.instance.signOut();
  }

  String searchText = "";

  void _showSearchBar(){
    setState(() {
      searchText = "";
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedFilter = filters[0];
      selectedItem = navigationItems[0];
    });
  }

  void _onSearchTextChanged(String text){
    setState(() {
      searchText = text;
    });
  }

//go to profile page method
void goToProfilePage() {
  // pop menu 
  Navigator.pop(context);

  //go on profile page 
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => ProfilePage(),
  ),
  );
}
//log out button


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(onPressed: () => Scaffold.of(context).openDrawer(), 
          icon: Icon(
            Icons.sort,
            color: kPrimaryColor,
            size: 28,
          ),
          );
        }        
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        actions: [
          if(searchText.isEmpty)
          Padding(
            padding: EdgeInsets.only(right: 16,),
            child: IconButton(
              onPressed: _showSearchBar,
              icon: const Icon(Icons.search),
              color: Colors.grey[400],
            ),
          ),
        ],
        //show the search bar when theres no text in the search bar 
        title: searchText.isNotEmpty
            ? TextField(
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            )
          : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 8,
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  "Discover books",
                  style: GoogleFonts.catamaran(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    height: 1,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                Padding(
                  padding: EdgeInsets.only(right: 75),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: buildFilters(),
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            child: Container(
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildBooks(),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Authors to follow",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      Row(
                        children: [

                          Text(
                            "Show all",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),

                          SizedBox(
                            width: 8,
                          ),

                          IconButton (
                          onPressed: _goToProfilePage,
                          icon: const Icon(Icons.search),
                          color: Colors.grey[400],
                          ),

                        ],
                      ),

                    ],
                  ),
                ),

                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: buildAuthors(),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildNavigationItems(),
        ),
      ),
    );
  }

  List<Widget> buildFilters(){
    List<Widget> list = [];
    for (var i = 0; i < filters.length; i++) {
      list.add(buildFilter(filters[i]));
    }
    return list;
  }

  Widget buildFilter(Filter item){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = item;
        });
      },
      child: Container(
        height: 50,
        child: Stack(
          children: <Widget>[

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 30,
                height: 3,
                color: selectedFilter == item ? kPrimaryColor : Colors.transparent,
              ),
            ),

            Center(
              child: Text(
                item.name,
                style: GoogleFonts.catamaran(
                  color: selectedFilter == item ? kPrimaryColor : Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  List<Widget> buildBooks(){
    List<Widget> list = [];
    for (var i = 0; i < books.length; i++) {
      list.add(buildBook(books[i], i));
    }
    return list;
  }

  Widget buildBook(Book book, int index){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetail(book: book)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 32, left: index == 0 ? 16 : 0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 16, top: 24,),
                child: Hero(
                  tag: book.title,
                  child: Image.asset(
                    book.image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            Text(
              book.title,
              style: GoogleFonts.catamaran(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              book.author.fullname,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }

  List<Widget> buildAuthors(){
    List<Widget> list = [];
    for (var i = 0; i < authors.length; i++) {
      list.add(buildAuthor(authors[i], i));
    }
    return list;
  }

  Widget buildAuthor(Author author, int index){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0),
      width: 255,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Card(
            elevation: 4,
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(author.image), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 12,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                author.fullname,
                style: GoogleFonts.catamaran(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [

                  Icon(
                    Icons.library_books,
                    color: Colors.grey,
                    size: 14,
                  ),

                  SizedBox(
                    width: 8,
                  ),
                  
                  Text(
                    author.books.toString() + " books",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),

            ],
          ),

        ],
      ),
    );
  }

  List<Widget> buildNavigationItems(){
    List<Widget> list = [];
    for (var navigationItem in navigationItems) {
      list.add(buildNavigationItem(navigationItem));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = item;
        });
      },
      child: Container(
        width: 50,
        child: Center(
          child: Icon(
            item.iconData,
            color: selectedItem == item ? kPrimaryColor : Colors.grey[400],
            size: 28,
          ),
        ),
      ),
    );
  }

}