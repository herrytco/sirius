import 'package:flutter_test/flutter_test.dart';
import 'package:sirius/i_dpa_entity.dart';
import 'package:sirius/i_dpa_factory.dart';
import 'package:sirius/i_dpa_repository.dart';

void main() {
  test('basic document test', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    DocumentRepository documentRepository = DocumentRepository();

    Document d1 = Document();
    d1.title = "Scientific Writing";

    await documentRepository.add(d1);
    
    print("done");
  });
}

class DocumentRepository extends DPARepository<Document, DocumentFactory> {
  DocumentRepository() : super(DocumentFactory());
}

class DocumentFactory extends DPAFactory<Document> {
  @override
  Document get entity => Document();

  @override
  Document fromMap(Map<String, dynamic> data) {
    Document doc = Document();

    if (!data.containsKey(Document.cId))
      throw Exception("primary key missing!");

    doc.id = data[Document.cId];

    if (data.containsKey(Document.cTitle)) doc.title = data[Document.cTitle];

    return doc;
  }
}

class Document extends DPAEntity {
  static final String cId = "id";
  static final String cTitle = "title";

  int id;
  String title;

  @override
  void registerFields() {
    registerField(cId, DataType.IntegerAuto, primaryKey: true);
    registerField(cTitle, DataType.String);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      cId: id,
      cTitle: title,
    };
  }
}
