import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/components/components.dart';
import 'package:flutter_clean_architecture/core/utils/utils.dart';
import 'package:go_router/go_router.dart';


import '../../../../core/dependency_injection/di_barrel.dart';
import '../../../../core/router/app_routes.dart';
import '../cubit/cart_cubit.dart';
import '../data/model/request/cart_add_params.dart';
import '../data/model/response/response.dart';



part 'cart_listing_view.dart';
part 'cart_post_view.dart';