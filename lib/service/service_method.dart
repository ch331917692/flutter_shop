import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future getHomePageContent() async {
  var formData = {'lon':'115.02932','lat':'35.76189'};

  return request("homePageContent", formData:formData);
}


Future getHomePageBelowConten() async {

  return request("homePageBelowConten", formData:1);

}

Future request(url, {formData}) async {
  try {
    print("开始获取Data");
    Response response;
    Dio dio = Dio();
    dio.options.connectTimeout = 1000;
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    if(formData == null){
      response = await dio.post(servicePath[url]);
    }else{
      response = await dio.post(servicePath[url], data: formData);
    }
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print("ERROR:=========>$e");
  }
}


