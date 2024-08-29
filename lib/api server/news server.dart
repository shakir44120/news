import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = 'ad6caf174a264f97b6a7848178e474cf';
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchBitcoinNews() async {
    final response = await http
        .get(Uri.parse('$baseUrl/everything?q=bitcoin&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load Bitcoin news');
    }
  }

  Future<List<dynamic>> fetchAppleNews() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/everything?q=apple&from=2024-08-04&to=2024-08-04&sortBy=popularity&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load Apple news');
    }
  }

  Future<List<dynamic>> fetchTechCrunchAndNextWebNews() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/everything?domains=techcrunch.com,thenextweb.com&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load TechCrunch and NextWeb news');
    }
  }

  Future<List<dynamic>> fetchTopHeadlinesUS() async {
    final response = await http
        .get(Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load US headlines');
    }
  }

  Future<List<dynamic>> fetchTopHeadlinesBBC() async {
    final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?sources=bbc-news&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load BBC headlines');
    }
  }

  Future<List<dynamic>> fetchTopHeadlinesGermanyBusiness() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/top-headlines?country=de&category=business&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load Germany business headlines');
    }
  }

  Future<List<dynamic>> fetchTopHeadlinesTrump() async {
    final response = await http
        .get(Uri.parse('$baseUrl/top-headlines?q=trump&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load Trump headlines');
    }
  }

  Future<List<dynamic>> fetchCategoriesNewsApi(String category) async {
    String url = '$baseUrl/everything?q=${category}&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Error, News not found!');
    }
  }
}
