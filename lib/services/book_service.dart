import 'package:appwrite/appwrite.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BookService {
  Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject('6719d1d0001cf69eb622');

  late Databases database;

  BookService() {
    database = Databases(client);
  }

  Stream<List<Map<String, dynamic>>> streamBooks() {
    return database
        .listDocuments(
          databaseId: '6719d29f00248a2fe2b7',
          collectionId: '6719dfda001c33dbd30d',
        )
        .then((response) => response.documents.map((doc) => doc.data).toList())
        .asStream();
  }

  // this is to fetch books by categories
  Future<List<Map<String, dynamic>>> fetchBooksByCategory(
      String category) async {
    try {
      final response = await database.listDocuments(
        collectionId: '6719dfda001c33dbd30d',
        queries: [
          Query.equal('Category', category),
        ],
        databaseId: '6719d29f00248a2fe2b7',
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error fetching books by category: $e');
      return [];
    }
  }

  // this is to fetch categories

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await database.listDocuments(
        collectionId: 'books-categories',
        databaseId: '6719d29f00248a2fe2b7',
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchBookDetails(String title, String s) async {
    // Implement your book fetching logic here
    // For example:
    return {
      'title': title,
      'description': 'Book description',
      // ... other book details
    };
  }

   static const String baseUrl = 'https://cloud.appwrite.io/v1';
  
  Future<List<Map<String, dynamic>>> fetchNotesByQuery(String query) async {
    try {
      // Add headers if required by your API
      final headers = {
        'Content-Type': 'application/json',
        // Add any authentication headers if needed
        // 'Authorization': 'Bearer YOUR_TOKEN',
      };

      // Create proper URL with query parameter
      final uri = Uri.parse('$baseUrl/notes').replace(
        queryParameters: {'search': query},
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Ensure we're properly handling the JSON response
        final dynamic responseData = json.decode(response.body);
        
        // Handle different response structures
        List<dynamic> data;
        if (responseData is Map) {
          // If the response is wrapped in an object
          data = responseData['data'] ?? responseData['notes'] ?? [];
        } else if (responseData is List) {
          // If the response is directly an array
          data = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        // Convert and filter the data
        return data.where((note) {
          // Safely access the title with null checking
          final title = note['title']?.toString().toLowerCase() ?? '';
          final content = note['content']?.toString().toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          
          // Search in both title and content
          return title.contains(searchQuery) || content.contains(searchQuery);
        }).map((note) {
          // Ensure we return a Map<String, dynamic>
          return note is Map<String, dynamic> 
              ? note 
              : Map<String, dynamic>.from(note);
        }).toList();
      } else {
        throw Exception('Failed to load notes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notes: $e');
      rethrow; // Rethrow to handle in UI
    }
  }
}