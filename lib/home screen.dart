import 'package:flutter/material.dart';
import 'package:news/CATEGORY.dart';
import 'package:news/api%20server/news%20server.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> news;
  final NewsService newsService = NewsService();
  String currentChannel = 'US News';

  @override
  void initState() {
    super.initState();
    news = newsService.fetchTopHeadlinesUS(); // Default to US headlines
  }

  void _updateNews(Future<List<dynamic>> newNews, String channel) {
    setState(() {
      news = newNews;
      currentChannel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('DAILY NEWS')),
        leading: IconButton(
          icon: Icon(Icons.apps),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Bitcoin news':
                  _updateNews(newsService.fetchBitcoinNews(), 'Bitcoin news');
                  break;
                case 'Apple news':
                  _updateNews(newsService.fetchAppleNews(), 'Apple news');
                  break;
                case 'TechCrunch news':
                  _updateNews(newsService.fetchTechCrunchAndNextWebNews(),
                      'TechCrunch news');
                  break;
                case 'US News':
                  _updateNews(newsService.fetchTopHeadlinesUS(), 'US News');
                  break;
                case 'BBC News':
                  _updateNews(newsService.fetchTopHeadlinesBBC(), 'BBC News');
                  break;
                case 'Germany Business news':
                  _updateNews(newsService.fetchTopHeadlinesGermanyBusiness(),
                      'Germany Business news');
                  break;
                case 'Trump news':
                  _updateNews(
                      newsService.fetchTopHeadlinesTrump(), 'Trump news');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                'Bitcoin news',
                'Apple news',
                'TechCrunch news',
                'US News',
                'BBC News',
                'Germany Business news',
                'Trump news',
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          }

          final articles = snapshot.data!;
          return Column(
            children: [
              Container(
                height: 300, // Height of the large containers
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Container(
                      width: 300,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16), // Apply rounded corners to all sides
                        child: Stack(
                          children: <Widget>[
                            if (article['urlToImage'] != null)
                              Positioned.fill(
                                child: Image.network(
                                  article['urlToImage'],
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.image_not_supported,
                                          size: 100),
                                    );
                                  },
                                ),
                              ),
                            if (article['urlToImage'] == null)
                              Positioned.fill(
                                child: Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 100),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.black.withOpacity(0.5),
                                child: Text(
                                  article['title'] ?? 'No title',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      currentChannel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 150,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey, // Fallback color
                              image: article['urlToImage'] != null
                                  ? DecorationImage(
                                      image:
                                          NetworkImage(article['urlToImage']),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {
                                        // handle the error
                                      },
                                    )
                                  : null,
                            ),
                            child: article['urlToImage'] == null
                                ? Center(
                                    child: Icon(Icons.image_not_supported,
                                        size: 50),
                                  )
                                : null,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article['title'] ?? 'No title',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  article['description'] ?? 'No description',
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
