import 'package:flutter_google_sheet_api/model/StudentDataModel.dart';
import 'package:flutter_google_sheet_api/model/data_model.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/material.dart';

class StudentSheetApi{

  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "studentdata-347013",
  "private_key_id": "96c5aba7c8ac43597e4e043c40598529398262ce",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDSuyMHUAPiBovd\nHV0R5Dz2ME2JMILV5DgWvvk3MQ4quJvmgDLMipLbbjo3NUV+NbFLiogPqsfzhsiY\nSr1JmIs+SM0rlAAUaGfoP65+2bmnrJMF8MbtRl/UKnRoQHVIyIcasEltsuxK3A1m\nuUzS+jNrvzPpA8jqrmJUTAR/hBEpIxpPtae7kzKr4Ua5SXjcWOc4N8L631hSwNAc\nEnf1eHYTO+tnU06qZDceh0+Fg+RrckJIXQt8NRooSaHB8UwKZf2FFBzuT4lpwPZu\nGxFYcFQu0ktOdgwWNxSDt/7CtIzlmylTyozRcXJHTWT2YOiCDqBPzRq6+sLWpcVv\nwi3mse2bAgMBAAECggEABEIazzMebCrrGM2jy7cO3xl5X59qBwELFYHINTjNCy9a\nzlNJDRmmjD+TqcaH5nWwS137w0R75BLId+dYU6XjXmyH+zlZsEMVCNWy/kY11Bd1\nJLNJjPh7x3F2+h2Fust7WDgEUjt02Eubch4/2RC/b3Rxvv1ZsIBTy7wTgf4jS9XF\ncuiSt1PRQ+PtgotjCQkvCvjcF99NLdGUA1NbhWI337pOmjRA6WsYxBCaFlfObu2h\nWKkbBCoiIaVX7FaTuJH8ldkarUVg+hjNWAwAf1jFeJG68/15hp9MnxtqKXXzgrEM\nEdCsaF1O6GAk63Ns1wc3UnWtpPZLTj9lzMoftXYBKQKBgQD26IDaTtPEWsesaVKH\nZIVwVFU4hSElSSuHP7ccXYXevJzvRawhUwA6xwqrWCrJMpWDDgeeNvOmsi/4dKBa\npjjAxSyKf/bcoRu2knXAjOWl/wuuer+PYTGIngbGQ/mrCipSVRZiqPjw8Ngi1uD/\n1J9xzwTYOT1RIVn57Texq1UvGQKBgQDafZtKXFk/tVUae2bkjPN7CRi2gk8iD5p1\njaCmeUf3BIug9ubF3j3jLiToRX5hip64BOmGnoQ4kFtG0HUZiFftvLx/bvk6it4m\n5GnEhSnn+nX1oSgwVL+jIb8gKX9KWiTlXXmlOyQwXQo0TWbqbSDwg2lEQhNgZh2k\niooUY4x80wKBgQDJD9yd6cMZCrO++qVyC7F+H66mMAMl0cfYg1IhjycMkptZXWsm\nV+i/9IYDsfBllwOZjTs245jWDhRyRsauCt38XJRA1KO6VpeyvOGWwyXfXymsE9ka\ncRNdJRJvMbuGROjh0tg/z0mpKvdWp5Thv8t3ahWP3kzIXFhg5YOM8vCTQQKBgECD\nbBH12Kh2C23pWAVOFSqUEgb5zRHal5n0OqZNE1G9ttjNbnCoYY+t9VncAygb/SeK\n08VbEuF8xmbPcHQcjRH2c5YRF2gQzu2e7hgH1crYanIfprU2oOszMLL3bc1vdot/\nIUcHgnUBU90Dqcq4dExwEOoFtKD3JfOKsKC6kCXfAoGAUh9ngGh0P96/2sGjPq4k\n+PPZ0tMunZcn/R3uHuv8jF45F5f5QlxaAJ318itMYMnbQuoGTOozukK7jr5CZQTg\nDlnPl74Wq2a7BVwESUEQ24jUz0smwG7fekf6jFbkC9HTT+LalHSgYibmTAIuNFuz\nsdJGwlGJQGBe9skkdP7OdXQ=\n-----END PRIVATE KEY-----\n",
  "client_email": "studentdata@studentdata-347013.iam.gserviceaccount.com",
  "client_id": "108264206655264357404",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/studentdata%40studentdata-347013.iam.gserviceaccount.com"
}
  ''';
  static final _spreadSheetId = "1Wi6DATJZddrbY8E8-qzzJoPZvqiXnIbOk_MOZPf1Hzc";
  static final _studentData = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {

    try{
      final spreadSheet = await _studentData.spreadsheet(_spreadSheetId);

      _userSheet = await _getWorkSheet(spreadSheet,title : 'StudentData');

      final firstRow = DataModel.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    }catch (e){
      print('Init error : $e');
    }

  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,{required String title}) async {
    try{
      return await spreadsheet.addWorksheet(title);
    }catch (e){
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String , dynamic>> list) async {

    if(_userSheet == null){
      return false;
    }

    _userSheet!.values.map.appendRows(list);

    return true;

  }




}