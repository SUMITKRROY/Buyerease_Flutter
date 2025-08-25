//
//
// import 'package:sqflite/sqflite.dart';
//
// import '../database/database_helper.dart';
// import '../model/SysData22Modal.dart';
//
// /**
//  * Created by Roy on 18/08/2025.
//  */
//
//   class SysData22Handler {
//
//     static String TAG = "GeneralMasterHandler";
//
//     static Future<bool> insertSysData22Master( SysData22Modal sysData22Modal) async {
//         try {
//             final db = await DatabaseHelper().database;
//             Map<String, dynamic> contentValues = {
//                 'GenID': sysData22Modal.genId,
//                 'MainID': sysData22Modal.mainId,
//                 'SubID': sysData22Modal.subId,
//                 'MasterName': sysData22Modal.masterName,
//                 'MainDescr': sysData22Modal.mainDescr,
//                 'SubDescr': sysData22Modal.subDescr,
//                 'numVal1': sysData22Modal.numVal1,
//                 'numVal2': sysData22Modal.numVal2,
//                 'AddonInfo': sysData22Modal.addonInfo,
//                 'MoreInfo': sysData22Modal.moreInfo,
//                 'Priviledge': sysData22Modal.priviledge,
//                 'a': sysData22Modal.a,
//                 'ModuleAccess': sysData22Modal.moduleAccess,
//                 'ModuleID': sysData22Modal.moduleId,
//             };
//
//             // First try update
//             int rows = await db.update(
//                 'Sysdata22',
//                 contentValues,
//                 where: 'MainID = ?',
//                 whereArgs: [sysData22Modal.mainId],
//             );
//
//             if (rows == 0) {
//                 // Insert if update did not happen
//                 await db.insert('Sysdata22', contentValues);
//             }
//
//             return true;
//         } catch (e) {
//             print("Exception inserting Sysdata22: $e");
//             return false;
//         }
//     }
//
//     static Future<List<SysData22Modal>> getSysData22ListAccToID(
//         String genId, String mainId) async {
//         List<SysData22Modal> lGeneral = [];
//         final db = await DatabaseHelper().database;
//         try {
//             String query = '''
//       SELECT * FROM Sysdata22
//       WHERE GenID = ? AND MainID = ?
//       ORDER BY MainID
//     ''';
//
//             final List<Map<String, dynamic>> result =
//             await db.rawQuery(query, [genId, mainId]);
//
//             for (var row in result) {
//                 lGeneral.add(SysData22Modal.fromMap(row));
//             }
//
//             print("Count of founded list of general: ${lGeneral.length}");
//         } catch (e) {
//             print("Error in getSysData22ListAccToID: $e");
//         }
//
//         return lGeneral;
//     }
//
//
//     static Future<List<SysData22Modal>> getSysData22List(
//         String genId) async {
//         List<SysData22Modal> lGeneral = [];
//         final db = await DatabaseHelper().database;
//         try {
//             String query = '''
//       SELECT * FROM Sysdata22
//       WHERE GenID = ?
//       ORDER BY MainID
//     ''';
//
//             final List<Map<String, dynamic>> result =
//             await db.rawQuery(query, [genId]);
//
//             for (var row in result) {
//                 lGeneral.add(SysData22Modal.fromMap(row));
//             }
//
//             print("Count of founded list of general: ${lGeneral.length}");
//         } catch (e) {
//             print("Error in getSysData22List: $e");
//         }
//
//         return lGeneral;
//     }
//
//
//     private static SysData22Modal getData(Cursor cursor) {
//
//         SysData22Modal sysData22Modal = new SysData22Modal();
//
//
//         sysData22Modal.GenID = cursor.getString(cursor.getColumnIndex("GenID"));
//         sysData22Modal.MainID = cursor.getString(cursor.getColumnIndex("MainID"));
//
//         sysData22Modal.SubID = cursor.getString(cursor.getColumnIndex("SubID"));
//         sysData22Modal.MasterName = cursor.getString(cursor.getColumnIndex("MasterName"));
//         sysData22Modal.MainDescr = cursor.getString(cursor.getColumnIndex("MainDescr"));
//         sysData22Modal.SubDescr = cursor.getString(cursor.getColumnIndex("SubDescr"));
//         sysData22Modal.numVal1 = cursor.getString(cursor.getColumnIndex("numVal1"));
//         sysData22Modal.numVal2 = cursor.getString(cursor.getColumnIndex("numVal2"));
//         sysData22Modal.AddonInfo = cursor.getString(cursor.getColumnIndex("AddonInfo"));
//         sysData22Modal.MoreInfo = cursor.getString(cursor.getColumnIndex("MoreInfo"));
//         sysData22Modal.Priviledge = cursor.getString(cursor.getColumnIndex("Priviledge"));
//
//         sysData22Modal.a = cursor.getString(cursor.getColumnIndex("a"));
//         sysData22Modal.ModuleAccess = cursor.getString(cursor.getColumnIndex("ModuleAccess"));
//         sysData22Modal.ModuleID = cursor.getString(cursor.getColumnIndex("ModuleID"));
//
//         return sysData22Modal;
//
//     }
//
//     public static List<SysData22Modal> getDataAccordingToParticularList(Context mContext, String GenId, String departmentId) {
//
//
//         DBHelper dbHelper = new DBHelper(mContext);
//         SQLiteDatabase database = dbHelper.getReadableDatabase();
//
//         String query = "SELECT * FROM " + "GenMst"
//                 + " WHERE " + "GenID" + "='" + GenId + "' AND " + "pGenRowID" + "='" + departmentId + "'";
//         FslLog.d(TAG, "query for  get closed general list  " + query);
//         Cursor cursor = database.rawQuery(query, null);
//
//         ArrayList<SysData22Modal> lGeneral = new ArrayList<SysData22Modal>();
//
//         if (cursor.getCount() > 0) {
//             for (int i = 0; i < cursor.getCount(); i++) {
//                 cursor.moveToNext();
//                 lGeneral.add(getData(cursor));
//             }
//         }
//         cursor.close();
//         database.close();
//         FslLog.d(TAG, " count of founded list of general " + lGeneral.size());
//         return lGeneral;
//     }
//
//     public static String getDataAccordingId(Context mContext, String pGenRowID) {
//
//
//         DBHelper dbHelper = new DBHelper(mContext);
//
//         SQLiteDatabase db = dbHelper.getReadableDatabase();
//
//         String query = "SELECT " + "MainDescr" + " FROM " + "GenMst"
//                 + " where " + "pGenRowID" + " = '" + pGenRowID + "'";
//
//         FslLog.d(TAG, " query for complaint name " + query);
//         Cursor cursor = db.rawQuery(query, null);
//         String MainDescr = null;
//         if (cursor.getCount() > 0) {
//             for (int i = 0; i < cursor.getCount(); i++) {
//                 cursor.moveToNext();
//                 MainDescr = cursor.getString(cursor.getColumnIndex("MainDescr"));
//             }
//         }
//         cursor.close();
//         db.close();
//
//         return MainDescr;
//     }
//
//
//     public static void handlerToSysData22Master(final Context mContext,
//                                                 final int isBackGround,
//                                                 final String dataFor,
//                                                 String filter,
//                                                 final CallBackResult callBackResult) {
//
//         String url = null;
//         UserSession userSession = new UserSession(mContext);
//         UserData userData = userSession.getLoginData();
//         final Map<String, String> params = new HashMap<String, String>();
//
//         params.put(KEY_USER_ID, userData.userId);
//
//         params.put(KEY_DATA_FILTER, filter);
//
//
//         FslLog.d(TAG, " master url " + url);
//         FslLog.d(TAG, " master  param " + new JSONObject(params));
//
//         if (!NetworkUtil.isNetworkAvailable(mContext)) {
//            Toast toast= ToastCompat.makeText(mContext, "No Network Connectivity ", Toast.LENGTH_SHORT);
//             GenUtils.safeToastShow(TAG, mContext, toast);
//             return;
//         }
//
//         HandleToConnectionEithServer handleToConnectionEithServer = new HandleToConnectionEithServer();
//         handleToConnectionEithServer.setRequest(url,
//                 new JSONObject(params), new HandleToConnectionEithServer.CallBackResult() {
//                     @Override
//                     public void onSuccess(JSONObject result) {
//                         if (isBackGround == FEnumerations.E_SYNC_IN_BACKGROUND) {
//                             handleOfGenMaster(mContext, dataFor, result);
//                         } else {
//                             callBackResult.onSuccess(result);
//                         }
//                     }
//
//                     @Override
//                     public void onError(VolleyError volleyError) {
//                         callBackResult.onError(volleyError);
//                     }
//                 });
//
//
//     }
//
//     private static void handleOfGenMaster(Context mContext, String generalMasterType, JSONObject result) {
//         List<SysData22Modal> lGeneralModelTypeList = parseComplaintType(generalMasterType, result);
//         if (mContext != null && lGeneralModelTypeList != null && lGeneralModelTypeList.size() > 0) {
//             updateDataBaseOfGeneralMaster(mContext, lGeneralModelTypeList);
//         }
//     }
//
//     public static void updateDataBaseOfGeneralMaster(Context mContext, List<SysData22Modal> lGeneralModelTypeList) {
//         if (mContext != null && lGeneralModelTypeList != null && lGeneralModelTypeList.size() > 0) {
//             for (int i = 0; i < lGeneralModelTypeList.size(); i++) {
//                 insertSysData22Master(mContext, lGeneralModelTypeList.get(i));
//             }
//         }
//
//     }
//
//     public static List<SysData22Modal> parseComplaintType(String generalMasterType, JSONObject jsonObject) {
//
//         List<SysData22Modal> generalModelList = null;
//         if (jsonObject != null) {
//             generalModelList = new ArrayList<>();
//             JSONArray jsonArray = jsonObject.optJSONArray(generalMasterType);
//             if (jsonArray != null && jsonArray.length() > 0) {
//                 for (int i = 0; i < jsonArray.length(); i++) {
//                     JSONObject jsonObjectOfComplaint = jsonArray.optJSONObject(i);
//                     SysData22Modal complaintModel = new SysData22Modal();
// //                    complaintModel.GEN_NAME = jsonObjectOfComplaint.optString("Name");
// //                    complaintModel.SERVER_GENERAL_MASTER_ID = jsonObjectOfComplaint.optString("ID");
// //                    complaintModel.GENID = jsonObjectOfComplaint.optString("GenID");
// //                    complaintModel.BBRV = jsonObjectOfComplaint.optString("Abbrv");
// //                    complaintModel.RECOVER_DATE = jsonObjectOfComplaint.optString(RECOVER_DATE);
//
//                     generalModelList.add(complaintModel);
//                 }
//             }
//
//         }
//
//         return generalModelList;
//     }
//
//     public interface CallBackResult {
//         public void onSuccess(JSONObject resultResponse);
//
//         public void onError(VolleyError volleyError);
//     }
// }
