import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadWriteFileExample(),
    );
  }
}

class ReadWriteFileExample extends StatefulWidget {
  const ReadWriteFileExample({super.key});

  @override
  State<ReadWriteFileExample> createState() => _ReadWriteFileExampleState();
}

class _ReadWriteFileExampleState extends State<ReadWriteFileExample> {
  final TextEditingController controller = TextEditingController();

  String filePath = 'Path to file';
  String content = 'Content';

  Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/myfile.txt');
  }

  Future<void> saveFile() async {
    try {
      final file = await getLocalFile();

      await file.writeAsString(controller.text);

      if (!mounted) return;

      setState(() {
        content = controller.text;
        filePath = file.path;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File saved successfully!')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save error: $e')));
    }
  }

  Future<void> loadFile() async {
    try {
      final file = await getLocalFile();

      if (!await file.exists()) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File not found! Press Save first.')),
        );
        return;
      }

      final text = await file.readAsString();

      if (!mounted) return;

      setState(() {
        controller.text = text;
        content = text;
        filePath = file.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File loaded successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Load error: $e')));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local file read/write Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Write to local file', style: TextStyle(fontSize: 20)),

          const SizedBox(height: 10),

          TextField(
            controller: controller,
            maxLines: null,
            minLines: 3,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text here...',
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: loadFile,
                child: const Text('Load', style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: saveFile,
                child: const Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),

          const Divider(height: 30),

          Text(
            'Local file path:',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 5),

          SelectableText(filePath),

          const Divider(height: 30),

          Text(
            'Local file content:',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              content,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
