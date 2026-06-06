import os

path = "lib/features/people/domain/use_cases/people_usecases.dart"
with open(path, "r") as f:
    content = f.read()

content = content.replace("import 'package:dartz/dartz.dart';", "import 'package:fpdart/fpdart.dart';")
content = content.replace("import '../../../../globals/error/failures.dart';", "import '../../../../globals/error_handling/error_model.dart';")
content = content.replace("Failure", "ErrorModel")
content = content.replace("@lazySingleton\n", "")
content = content.replace("import 'package:injectable/injectable.dart';", "")

with open(path, "w") as f:
    f.write(content)

repo_path = "lib/features/people/data/repositories_impl/people_repository_impl.dart"
with open(repo_path, "r") as f:
    content = f.read()

content = content.replace("import 'package:dartz/dartz.dart';", "import 'package:fpdart/fpdart.dart';")
content = content.replace("import '../../../../globals/error/failures.dart';", "import '../../../../globals/error_handling/error_model.dart';")
content = content.replace("Failure", "ErrorModel")
content = content.replace("@LazySingleton(as: PeopleRepository)\n", "")
content = content.replace("import 'package:injectable/injectable.dart';", "")

with open(repo_path, "w") as f:
    f.write(content)

