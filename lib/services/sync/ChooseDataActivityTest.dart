import 'package:buyerease/model/status_modal.dart';

import '../../utils/app_constants.dart';
import '../../utils/multiple_image_handler.dart';
import '../SendDataHandler.dart';


public class ChooseDataActivity extends AppCompatActivity implements JsonKey, View.OnClickListener {


  String TAG = "ChooseDataActivity";
  UserSession userSession;
  static boolean active = false;
  TextView txtSyncCountSection;

  ProgressDialog loadingDialog;

  ProgressBar progress;

  CheckBox chkGetInspectionData, chkGetMasterData;
  Button getDataSubmit, sendSubmit, getStyleDataSubmit, sendStyleSubmit;
  //    ProgressBar getDataProgressBar;
  List<StatusModal> statusModalList;

  RecyclerView recyclerView;
  SyncStatusAdaptor syncStatusAdaptor;
  int mViewType, mSyncViewType;
  List<String> listedSyncIds = null;
  List<String> idsListForSync = new ArrayList<>();
  List<String> syncDoneProcess = new ArrayList<>();
  int totalIdsToSync;
  LinearLayout styleSyncContainer, poSyncContainer;

  Dialog customProgressDialog;
  ProgressBar progressDataSync;
  ImageView imgDataSyncSuccess;
  Button btnSyncImage;
  ImageView imgImageSyncSuccess;
  boolean isDataSyncComplete = false;
  TextView txtImageSyncCount;
  int totalImageCount = 0;
  int syncedImageCount = 0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.choose_activity);
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    this.getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    userSession = new UserSession(ChooseDataActivity.this);
    getSupportActionBar().setTitle("Buyerease");
    TextView companyName = (TextView) findViewById(R.id.companyName);
    String st = GenUtils.truncate(new UserSession(ChooseDataActivity.this).getCompanyName(), FClientConfig.COMPANY_TRUNC_LENGTH);
    companyName.setText(st);
    SetInitiateStaticVariable.setInitiateStaticVariable(ChooseDataActivity.this);
    if (savedInstanceState != null) {
      mViewType = savedInstanceState.getInt("type", 0);
      mSyncViewType = savedInstanceState.getInt("mSyncViewType", 0);
    } else {
      mViewType = getIntent().getIntExtra("type", 0);
      mSyncViewType = getIntent().getIntExtra("mSyncViewType", 0);
    }
    if (getIntent().hasExtra("list")) {
      listedSyncIds = getIntent().getStringArrayListExtra("list");
    }

    styleSyncContainer = (LinearLayout) findViewById(R.id.styleSyncContainer);
    poSyncContainer = (LinearLayout) findViewById(R.id.poSyncContainer);

    chkGetInspectionData = (CheckBox) findViewById(R.id.chkGetInspectionData);
    chkGetMasterData = (CheckBox) findViewById(R.id.chkGetMasterData);
    getDataSubmit = (Button) findViewById(R.id.getDataSubmit);
    sendSubmit = (Button) findViewById(R.id.sendSubmit);
    getStyleDataSubmit = (Button) findViewById(R.id.getStyleDataSubmit);
    sendStyleSubmit = (Button) findViewById(R.id.sendStyleSubmit);

//        getDataProgressBar = (ProgressBar) findViewById(R.id.getDataProgressBar);

    txtSyncCountSection = (TextView) findViewById(R.id.txtSyncCountSection);
//        if (!chkGetInspectionData.isChecked() && !chkGetMasterData.isChecked()) {
//            disableGetDataButton();
//        }

    if (mSyncViewType == FEnumerations.E_VIEW_TYPE_HOLOGRAM_STYLE) {
      poSyncContainer.setVisibility(View.GONE);
      styleSyncContainer.setVisibility(View.VISIBLE);
      getStyleDataSubmit.setOnClickListener(this);
      sendStyleSubmit.setOnClickListener(this);
      handleHologramView();
      handleToCreateHologramDb();
    } else {
      poSyncContainer.setVisibility(View.VISIBLE);
      styleSyncContainer.setVisibility(View.GONE);
      getDataSubmit.setOnClickListener(this);
      sendSubmit.setOnClickListener(this);
      handleView();
    }


  }

  void handleToCreateHologramDb() {
    StyleHandler.checkAndCreateTable(ChooseDataActivity.this);
  }

  void handleHologramView() {
    if (mViewType == FEnumerations.E_VIEW_ONLY_SEND) {
      findViewById(R.id.getStyleDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.sendStyleDataCardContainer).setVisibility(View.VISIBLE);
      findViewById(R.id.syncContainer).setVisibility(View.VISIBLE);
      InitilizaeStatusHologramView();
    } else {
      findViewById(R.id.getStyleDataCardContainer).setVisibility(View.VISIBLE);
      findViewById(R.id.sendStyleDataCardContainer).setVisibility(View.VISIBLE);
      findViewById(R.id.syncContainer).setVisibility(View.GONE);
    }
  }


  void handleView() {

    if (mViewType == FEnumerations.E_VIEW_ONLY_SYNC) {
      findViewById(R.id.getDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.sendDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.syncContainer).setVisibility(View.VISIBLE);
      InitilizaeStatusView();


    } else if (mViewType == FEnumerations.E_VIEW_SEND_AND_SYNC) {
      findViewById(R.id.getDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.sendDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.syncContainer).setVisibility(View.VISIBLE);
      InitilizaeStatusView();


    } else {
      findViewById(R.id.getDataCardContainer).setVisibility(View.VISIBLE);
      findViewById(R.id.sendDataCardContainer).setVisibility(View.GONE);
      findViewById(R.id.syncContainer).setVisibility(View.GONE);


    }


  }

  void InitilizaeStatusHologramView() {
    if (listedSyncIds != null && listedSyncIds.length > 0) {
      FslLog.d(TAG, "Select list ids : %s%n " + listedSyncIds.toString());
      Set<String> hashsetList = new HashSet<String>(listedSyncIds);
      FslLog.d(TAG, "\nUnique list ids  : %s%n " + hashsetList.toString());
      idsListForSync.addAll(hashsetList);
      handleListToSync();
      viewStatusListOfSyncOfStyleHologram();
      handleToSynsStyle();
    }

  }

  void InitilizaeStatusView() {
    if (listedSyncIds != null && listedSyncIds.length > 0) {
      totalIdsToSync = listedSyncIds.length;
    }
    handleListToSync();
    handleToSendData();
  }

  void handleToSendData() {
    updateStatusUI();
    if (listedSyncIds != null && listedSyncIds.length > 0) {
      idsListForSync.add(listedSyncIds[0]);
      viewStatusListOfSync();
      getDELToSunc();
    }

  }

  void getDELToSunc() {
    handleToHeaderSync();
  }

  void handleToHeaderSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      //for testing purpose
//            SendDataHandler.getOnSiteDataData(ChooseDataActivity.this, idsListForSync);
//            SendDataHandler.getPkgAppearanceData(ChooseDataActivity.this, idsListForSync);
//            SendDataHandler.getSampleCollectedData(ChooseDataActivity.this, idsListForSync);

     Future<dynamic> hdrTables = SendDataHandler.getHdrTableData( idsListForSync);
      print("header table data $hdrTables");
      if (hdrTables != null && hdrTables.length > 0) {
        updateSyncList(FEnumerations.syncHeaderTable, FEnumerations.syncPendingStatus);
        final Map<String, dynamic> inspectionData = {};
        final data = <String, dynamic>{};

        data["Data"] = hdrTables; // assuming hdrTables is already a Map or compatible
        data["ImageFiles"] = "";
        data["EnclosureFiles"] = "";
        data["TestReportFiles"] = "";
        data["Result"] = true;
        data["Message"] = "";
        data["MsgDetail"] = "";


        inspectionData["InspectionData"] = data;

        print("params getHdrTableData $inspectionData");
        print(" Header sync .........................................\n\n");

        SendDataHandler.sendData( inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSizeQtySync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_HEADER_TABLE + " \n" + msg);
        handleToSizeQtySync();//added by shekhar
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToImageSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM HDR TO SYNC..........");
      }
    }
  }
  void handleToSizeQtySync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> hdrTables = SendDataHandler.getSizeQtyData(ChooseDataActivity.this, idsListForSync);
      if (hdrTables != null && hdrTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_SIZE_QUANTITY_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(hdrTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);

        FslLog.d(TAG, " Header sync .........................................\n\n");

        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_SIZE_QUANTITY_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToImageSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_SIZE_QUANTITY_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_SIZE_QUANTITY_TABLE + " \n" + msg);
        handleToImageSync();//added by shekhar
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_HEADER_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToImageSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM HDR TO SYNC..........");
      }
    }
  }

  void handleToImageSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> imgTables = SendDataHandler.getImagesTableData(ChooseDataActivity.this, idsListForSync);
      if (imgTables != null && imgTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(imgTables));
//                Map<String, Object> imagesList = SendDataHandler.getImagesFileTableData(ChooseDataActivity.this, idsListForSync);
//                if (imagesList != null) {
//                    data.put("ImageFiles", imagesList.get("list"));
//                } else {
        data.put("ImageFiles", "");
//                }

        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);

        FslLog.d(TAG, " IMAGES sync .........................................\n\n");

        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
//                            updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSingleImageSync();

        } else {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_IMAGES_TABLE + " \n" + msg);
        handleToSingleImageSync();//added by shekhar
//                            handleToWorkmanShipSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        handleToSingleImageSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM IMAGES TO SYNC..........");
      }
    }
  }


  void handleToSingleImageSync() {
    MyWorkerThread mWorkerThread;
    if (idsListForSync != null && idsListForSync.length > 0) {
      /* mWorkerThread = new MyWorkerThread(new Handler(), new MyWorkerThread.Callback() {
                @Override
                public void onImageUploaded(JSONObject result, int pos) {
                    FslLog.d(TAG, " response of sending image  " + result + " pos " + pos);
                    if ((idsListForSync.length - 1) == pos) {
                        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
                        handleToWorkmanShipSync();
                    }
                }

                @Override
                public void onErrorUploaded(VolleyError volleyError, int pos) {
                    FslLog.d(TAG, " error of sending image  " + volleyError + " pos " + pos);
//                    if ((idsListForSync.length - 1) == pos) {
//                        handleToWorkmanShipSync();
//                    }
                    updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
                    requestVolleyError(volleyError);
                }
            });
            mWorkerThread.start();
            mWorkerThread.prepareHandler();
            Random random = new Random();*/


      updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
//                final Map<String, Object> inspectionData = new HashMap<String, Object>();
      final Map<String, Object> data = new HashMap<String, Object>();
//                data.put("Data", new JSONObject(imgTables));
      List<ImageModal> imagesList = SendDataHandler.getImagesFileArrayData(ChooseDataActivity.this, idsListForSync);
      List<String> syncedList = new ArrayList<>();
      if (imagesList != null && imagesList.length > 0) {
        data.put("FileType", FEnumerations.E_SEND_FILE_IMAGE_INSPECTION);
        for (int i = 0; i < imagesList.length; i++) {
          ImageModal imageModal = imagesList.get(i);
          Map<String, Object> jsonObj = new HashMap<String, Object>();
//                    for (int j = 0; j < cursor.getColumnCount(); j++) {
//                    jsonObj.put("FileName", cursor.getString(cursor.getColumnIndex("ImageName")));
          jsonObj.put("pRowID", imageModal.pRowID);
          jsonObj.put("QRHdrID", imageModal.QRHdrID);
          jsonObj.put("QRPOItemHdrID", imageModal.QRPOItemHdrID);
          jsonObj.put("Length", imageModal.Length);


          jsonObj.put("FileName", imageModal.FileName);

//                    String file = cursor.getString(cursor.getColumnIndex("fileContent"));
//                    if (!TextUtils.isEmpty(file) && !file.equals("null")) {
//                        byte[] decodedBytes = Base64.decode(file, 1);
//                        jsonObj.put("fileContent", decodedBytes);
//                    } else {


          String base64 = null;
          BitmapFactory.Options bmOptions = new BitmapFactory.Options();
          Bitmap bitmap = BitmapFactory.decodeFile(imageModal.fileContent, bmOptions);
          if (bitmap != null)
            base64 = ImgToStringConverter.BitMapToStringT(BitmapUtil.CustomScaleBitmap(bitmap)); //ImgToStringConverter.encodeFileToBase64Binary(imageModal.fileContent);
          //                        byte[] compressed = GzipUtil.compress(base64);
//                        String result = Base64.encodeToString(compressed, Base64.DEFAULT);
          if (bitmap != null) {
            FslLog.d(TAG, " recycle bitmap.. ");
            bitmap.recycle();
            bitmap = null;
            System.gc();
          }

          jsonObj.put("fileContent", base64);

          data.put("FileData", new JSONObject(jsonObj));
//                    mWorkerThread.queueTask(data, i);
          SendDataHandler sendDataHandler = new SendDataHandler();
          sendDataHandler.handleRequest(data, i, new SendDataHandler.GetCallBackSendResult() {
          @Override
          public void onSuccess(JSONObject result, int postion) {
          if (result.has("Result")) {
          String pRowID = result.optString("Result");
          syncedList.add(pRowID);
          ItemInspectionDetailHandler.updateImageToSync(ChooseDataActivity.this, pRowID);
          String str = syncedList.length + "/" + imagesList.length;
          updateSyncTitleList(FEnumerations.E_SYNC_IMAGES_TABLE, str);
          }
          FslLog.d(TAG, " response of sending image  " + result + " pos " + postion);
          if (imagesList.length == syncedList.length) {
          updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
          handleToWorkmanShipSync();
          }
          }

          @Override
          public void onError(VolleyError volleyError, int postion) {
          FslLog.d(TAG, " error of sending image  " + volleyError + " pos " + postion);
          updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
          String str = syncedList.length + "/" + imagesList.length + " Internet disconnect please try again.";
          updateSyncTitleList(FEnumerations.E_SYNC_IMAGES_TABLE, str);
          requestVolleyError(volleyError);
//                            handleToWorkmanShipSync();
          }
          });
        }
      } else {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToWorkmanShipSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM IMAGES TO SYNC..........");
      }
    }
  }


  void handleToWorkmanShipSync() {

    if (idsListForSync != null && idsListForSync.length > 0) {
      /*SendDataHandler.getOnSiteDataData(ChooseDataActivity.this, idsListForSync);
            SendDataHandler.getPkgAppearanceData(ChooseDataActivity.this, idsListForSync);
            SendDataHandler.getSampleCollectedData(ChooseDataActivity.this, idsListForSync);*/

      Map<String, Object> workTables = SendDataHandler.getWorkmanShipData(ChooseDataActivity.this, idsListForSync);
      if (workTables != null && workTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_WORKMANSHIP_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(workTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " WORKMANSHIP sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_WORKMANSHIP_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToItemMeasurementSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_WORKMANSHIP_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_WORKMANSHIP_TABLE + " \n" + msg);
        handleToItemMeasurementSync();//added by shekhar
//                            handleToPkgAppearanceSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_WORKMANSHIP_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToItemMeasurementSync();//added by shekhar
//                        handleToPkgAppearanceSync();
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_WORKMANSHIP_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToItemMeasurementSync();
//                handleToPkgAppearanceSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM WORK MAN SHIP TO SYNC..........");
      }
    }
  }

  void handleToItemMeasurementSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> itemTables = SendDataHandler.getItemMeasurementData(ChooseDataActivity.this, idsListForSync);
      if (itemTables != null && itemTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(itemTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " ITEM MEASUREMENT sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFindingSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE + " \n" + msg);
//                            handleToFindingSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToFindingSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_ITEM_MEASUREMENT_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFindingSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM Item measurement TO SYNC..........");
      }
    }
  }


  void handleToFindingSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> findingTables = SendDataHandler.getFindingData(ChooseDataActivity.this, idsListForSync);
      if (findingTables != null && findingTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_FINDING_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(findingTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " FINDING sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_FINDING_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToQualityParameterSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_FINDING_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_FINDING_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_FINDING_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToQualityParameterSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_FINDING_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToQualityParameterSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM Finding TO SYNC..........");
      }
    }
  }

  void handleToQualityParameterSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> qualityTables = SendDataHandler.getQualityParameterData(ChooseDataActivity.this, idsListForSync);
      if (qualityTables != null && qualityTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(qualityTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " QUALITY PARAMETER sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFitnessCheckSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToFitnessCheckSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_QUALITY_PARAMETER_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFitnessCheckSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM quality parameter TO SYNC..........");
      }
    }
  }

  void handleToFitnessCheckSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> fitTables = SendDataHandler.getFitnessCheckData(ChooseDataActivity.this, idsListForSync);
      if (fitTables != null && fitTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_FITNESS_CHECK_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(fitTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " FITNESS CHECK sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_FITNESS_CHECK_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToProductionStatusSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_FITNESS_CHECK_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_FITNESS_CHECK_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_FITNESS_CHECK_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToProductionStatusSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_FITNESS_CHECK_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToProductionStatusSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM fitness check TO SYNC..........");
      }
    }
  }

  void handleToProductionStatusSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> prodTables = SendDataHandler.getProductionStatusData(ChooseDataActivity.this, idsListForSync);
      if (prodTables != null && prodTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(prodTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " PRODUCTION STATUS sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToIntimationSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToIntimationSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_PRODUCTION_STATUS_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToIntimationSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM  SYNC_PRODUCTION_STATUS_TABLE TO SYNC..........");
      }
    }
  }

  void handleToIntimationSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> intTables = SendDataHandler.getIntimationData(ChooseDataActivity.this, idsListForSync);
      if (intTables != null && intTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_INTIMATION_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(intTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " INTIMATION sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_INTIMATION_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToEnclosureSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_INTIMATION_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_INTIMATION_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_INTIMATION_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToEnclosureSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_INTIMATION_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSingleEnclosureSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM  SYNC_INTIMATION_TABLE TO SYNC..........");
      }
    }
  }


  void handleToEnclosureSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> enclTables = SendDataHandler.getQREnclosureData(ChooseDataActivity.this, idsListForSync);
      if (enclTables != null && enclTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(enclTables));
        data.put("ImageFiles", "");

//                Map<String, Object> enclosureList = SendDataHandler.getEnclosureFileTableData(ChooseDataActivity.this, idsListForSync);
//                if (enclosureList != null) {
//                    data.put("EnclosureFiles", enclosureList.get("list"));
//                } else {
        data.put("EnclosureFiles", "");
//                }

        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " ENCLOSURE sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this,
            inspectionData,
            "",
            new SendDataHandler.GetCallBackResult() {
            @Override
            public void onSuccess(JSONObject loginResponse) {
            if (loginResponse.optBoolean("Result")) {
            handleToSingleEnclosureSync();
            } else {
            updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
            String msg = loginResponse.optString("Message");
            FslLog.e(TAG, FEnumerations.E_SYNC_ENCLOSURE_TABLE + " \n" + msg);
            }
            }

            @Override
            public void onError(VolleyError volleyError) {
            updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
            requestVolleyError(volleyError);
            handleToSingleEnclosureSync();//added by shekhar
            }
            });
      } else {
        handleToSingleEnclosureSync();
        FslLog.d(TAG, "NO DATA FOUNDED FROM SYNC ENCLOSURE TABLE TO SYNC........");
      }
    }
  }

  void handleToSingleEnclosureSync() {
    MyWorkerThread mWorkerThread;
    if (idsListForSync != null && idsListForSync.length > 0) {
      /*mWorkerThread = new MyWorkerThread(new Handler(), new MyWorkerThread.Callback() {
                @Override
                public void onImageUploaded(JSONObject result, int pos) {
                    FslLog.d(TAG, " response of sending enclosure  " + result + " pos : " + pos);
                    if ((idsListForSync.length - 1) == pos) {
                        updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
                        handleToDigitalsMultipleSync();
                    }
                }

                @Override
                public void onErrorUploaded(VolleyError volleyError, int pos) {
                    FslLog.d(TAG, " error of sending enclosure  " + volleyError + " pos : " + pos);
                    updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
                    requestVolleyError(volleyError);
//                    if ((idsListForSync.length - 1) == pos) {
//                        handleToDigitalsMultipleSync();
//                    }
                }
            });
            mWorkerThread.start();
            mWorkerThread.prepareHandler();
            Random random = new Random();*/

//            Map<String, Object> imgTables = SendDataHandler.getImagesTableData(ChooseDataActivity.this, idsListForSync);
//            if (imgTables != null && imgTables.length > 0) {
      updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
//                final Map<String, Object> inspectionData = new HashMap<String, Object>();
      final Map<String, Object> data = new HashMap<String, Object>();
//                data.put("Data", new JSONObject(imgTables));
      JSONArray imagesList = SendDataHandler.getEnclosureFileArrayData(ChooseDataActivity.this, idsListForSync);

      if (imagesList != null && imagesList.length() > 0) {
        data.put("FileType", FEnumerations.E_SEND_FILE_IMAGE_ENCLOSURE);
        for (int i = 0; i < imagesList.length(); i++) {
          data.put("FileData", imagesList.optJSONObject(i));
//                    mWorkerThread.queueTask(data, i);
          SendDataHandler sendDataHandler = new SendDataHandler();
          sendDataHandler.handleRequest(data, i, new SendDataHandler.GetCallBackSendResult() {
          @Override
          public void onSuccess(JSONObject result, int postion) {
          if (result.has("Result")) {
          String pRowID = result.optString("Result");
          ItemInspectionDetailHandler.updateQREnClosureToSync(ChooseDataActivity.this, pRowID);
          }
          FslLog.d(TAG, " response of sending image  " + result + " pos " + postion);
          if ((idsListForSync.length - 1) == postion) {
          updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
          handleToDigitalsMultipleSync();
          }
          }

          @Override
          public void onError(VolleyError volleyError, int postion) {
          FslLog.d(TAG, " error of sending image  " + volleyError + " pos " + postion);
          updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
          requestVolleyError(volleyError);
          }
          });
        }
      } else {
        updateSyncList(FEnumerations.E_SYNC_ENCLOSURE_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToDigitalsMultipleSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM ENCLOSURE TO SYNC..........");
      }
    }
  }

  void handleToDigitalsMultipleSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> digiTables = SendDataHandler.getDigitalsColumnFromMultipleData(ChooseDataActivity.this, idsListForSync);
      if (digiTables != null && digiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(digiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " DIGITAL sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFinalizeSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToFinalizeSync();//added by shekhar
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_DIGITAL_UPLOAD_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFinalizeSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM  SYNC_DIGITAL_UPLOAD_TABLE TO SYNC..........");
      }
    }
  }

  void handleToFinalizeSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> fiTables = SendDataHandler.getSelectedInspectionIdsData(ChooseDataActivity.this, idsListForSync);
      if (fiTables != null && fiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(fiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " FINALIZE sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        if (idsListForSync != null && idsListForSync.length > 0) {
        for (int i = 0; i < idsListForSync.length; i++) {
        ItemInspectionDetailHandler.updateFinalSync(ChooseDataActivity.this, idsListForSync.get(i));
        }
        }
//                            handleToSyncOtherDel();//comment by shekhar
        handleToPkgAppearanceSync();
        } else {
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_FINALIZE_TABLE + " \n" + msg);
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        handleToPkgAppearanceSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        handleToPkgAppearanceSync();
        requestVolleyError(volleyError);
        }
        });
      } else {
        FslLog.d(TAG, " NO DATA FOUNDED FROM  SYNC_DIGITAL_UPLOAD_TABLE TO SYNC..........");
      }
    }
  }

  void handleToPkgAppearanceSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> digiTables = SendDataHandler.getPkgAppearanceData(ChooseDataActivity.this, idsListForSync);
      if (digiTables != null && digiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_PKG_APPEARANCE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(digiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " PACKAGING APPEARANCE sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_PKG_APPEARANCE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToOnSiteBarcodeSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_PKG_APPEARANCE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_PKG_APPEARANCE + " \n" + msg);
        handleToOnSiteBarcodeSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_PKG_APPEARANCE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        handleToOnSiteBarcodeSync();
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_PKG_APPEARANCE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToOnSiteBarcodeSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM  PACKAGING APPEARANCE TO SYNC..........");
      }
    }
  }

  void handleToOnSiteBarcodeSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> digiTables = SendDataHandler.getOnSiteDataData(ChooseDataActivity.this, idsListForSync);
      if (digiTables != null && digiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(digiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " ON SITE sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSampleCollectedSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_ON_SITE + " \n" + msg);
        handleToSampleCollectedSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSampleCollectedSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM  ON SITE TO SYNC..........");
      }
    }
  }

  void handleToSampleCollectedSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> digiTables = SendDataHandler.getSampleCollectedData(ChooseDataActivity.this, idsListForSync);
      if (digiTables != null && digiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_SAMPLE_COLLECTED, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(digiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " SAMPLE COLLECTED sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_SAMPLE_COLLECTED, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToSyncOtherDel();//added by shekhar
        } else {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_ON_SITE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        updateSyncList(FEnumerations.E_SYNC_ON_SITE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        FslLog.d(TAG, " NO DATA FOUNDED FROM  SAMPLE COLLECTED TO SYNC..........");
      }
    }
  }


  void handleToSyncOtherDel() {
    if (listedSyncIds != null && listedSyncIds.length > 0 && idsListForSync.length > 0) {
      syncDoneProcess.add(idsListForSync.get(0));
      listedSyncIds.remove(idsListForSync.get(0));
      idsListForSync.clear();
      handleToSendData();
    }

  }

  void updateSyncList(String eSyncHeaderTable, int sts) {
    new Handler(Looper.getMainLooper()).post(() ->
        updateUI(eSyncHeaderTable,sts)
    );
  }
  void updateUI(String eSyncHeaderTable, int sts){
    if (statusModalList != null && statusModalList.length > 0) {
      int pos = -1;
      boolean isFound = false;
      for (int i = 0; i < statusModalList.length; i++) {
        if (statusModalList.get(i).tableName.equals(eSyncHeaderTable)) {
          pos = i;
          isFound = true;
          break;
        }
      }
      if (isFound && pos != -1) {
        statusModalList.get(pos).status = sts;
        if (syncStatusAdaptor != null) {
          syncStatusAdaptor.notifyDataSetChanged();
        }
      }
    }
  }


  void updateSyncTitleList(String eSyncHeaderTable, String sts) {
    if (statusModalList != null && statusModalList.length > 0) {
      int pos = -1;
      boolean isFound = false;
      for (int i = 0; i < statusModalList.length; i++) {
        if (statusModalList.get(i).tableName.equals(eSyncHeaderTable)) {
          pos = i;
          isFound = true;
          break;
        }
      }
      if (isFound && pos != -1) {
        statusModalList.get(pos).title = sts;
        if (syncStatusAdaptor != null) {
          syncStatusAdaptor.notifyDataSetChanged();
        }
      }

    }

  }

  void handleToSynsStyle() {
    handleToStyleSync();
  }

  void handleToStyleSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> param = StyleHandler.getStyleData(ChooseDataActivity.this, idsListForSync);
      if (param != null && param.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_STYLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(param));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);

        FslLog.d(TAG, " style sync .........................................\n\n");

        SendDataHandler.sendStyleData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_STYLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToStyleImageSync();
        } else {
        updateSyncList(FEnumerations.E_SYNC_STYLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_STYLE + " \n" + msg);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_STYLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        FslLog.d(TAG, " NO DATA FOUNDED FROM STYLE TO SYNC..........");
      }
    } else {
      FslLog.d(TAG, "No Selected style to sync...........");
    }

  }

  void handleToStyleImageSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> imgTables = StyleHandler.getStyleImagesTableData(ChooseDataActivity.this, idsListForSync);
      if (imgTables != null && imgTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(imgTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);

        FslLog.d(TAG, " IMAGES sync .........................................\n\n");

        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
//                            updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToStyleSingleImageSync();

        } else {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_IMAGES_TABLE + " \n" + msg);

//                            handleToWorkmanShipSync();
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        handleToStyleSingleImageSync();
        FslLog.d(TAG, " NO DATA FOUNDED FROM Style IMAGES TO SYNC..........");
      }
    }
  }

  void handleToStyleSingleImageSync() {

    updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
//                final Map<String, Object> inspectionData = new HashMap<String, Object>();
    final Map<String, Object> data = new HashMap<String, Object>();
//                data.put("Data", new JSONObject(imgTables));
    List<ImageModal> imagesList = StyleHandler.getStyleImagesForSync(ChooseDataActivity.this, idsListForSync);
    List<String> syncedList = new ArrayList<>();
    if (imagesList != null && imagesList.length > 0) {
      data.put("FileType", FEnumerations.E_SEND_FILE_IMAGE_STYLE);
      for (int i = 0; i < imagesList.length; i++) {
        ImageModal imageModal = imagesList.get(i);
        Map<String, Object> jsonObj = new HashMap<String, Object>();
//                    for (int j = 0; j < cursor.getColumnCount(); j++) {
//                    jsonObj.put("FileName", cursor.getString(cursor.getColumnIndex("ImageName")));
        jsonObj.put("pRowID", imageModal.pRowID);
        jsonObj.put("QRPOItemHdrID", imageModal.QRPOItemHdrID);
//                jsonObj.put("recUser", imageModal.U);//contentValues.put("recUser", userId);
        jsonObj.put("Length", imageModal.Length);
        jsonObj.put("FileName", imageModal.FileName);

        String base64 = null;
        BitmapFactory.Options bmOptions = new BitmapFactory.Options();
        Bitmap bitmap = BitmapFactory.decodeFile(imageModal.fileContent, bmOptions);
        if (bitmap != null)
          base64 = ImgToStringConverter.BitMapToStringT(BitmapUtil.CustomScaleBitmap(bitmap)); //ImgToStringConverter.encodeFileToBase64Binary(imageModal.fileContent);
        //                        byte[] compressed = GzipUtil.compress(base64);
//                        String result = Base64.encodeToString(compressed, Base64.DEFAULT);

        if (bitmap != null) {
          FslLog.d(TAG, " recycle bitmap.. ");
          bitmap.recycle();
          bitmap = null;
          System.gc();
        }

        jsonObj.put("fileContent", base64);

        data.put("FileData", new JSONObject(jsonObj));
//                    mWorkerThread.queueTask(data, i);
        SendDataHandler sendDataHandler = new SendDataHandler();
        sendDataHandler.handleStyleRequest(data, i, new SendDataHandler.GetCallBackSendResult() {
        @Override
        public void onSuccess(JSONObject result, int postion) {
        if (result.has("Result")) {
        String pRowID = result.optString("Result");
        syncedList.add(pRowID);
        StyleHandler.updateImageToSync(ChooseDataActivity.this, pRowID);
        String str = syncedList.length + "/" + imagesList.length;
        updateSyncTitleList(FEnumerations.E_SYNC_IMAGES_TABLE, str);

        }
        FslLog.d(TAG, " response of sending image  " + result + " pos " + postion);
        if (imagesList.length == syncedList.length) {
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        handleToFinalizeStyleSync();

        }
        }

        @Override
        public void onError(VolleyError volleyError, int postion) {
        FslLog.d(TAG, " error of sending image  " + volleyError + " pos " + postion);
        updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        String str = syncedList.length + "/" + imagesList.length + " Internet disconnect please try again.";
        updateSyncTitleList(FEnumerations.E_SYNC_IMAGES_TABLE, str);
        requestVolleyError(volleyError);
        }
        });
      }
    } else {
      updateSyncList(FEnumerations.E_SYNC_IMAGES_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
      FslLog.d(TAG, " NO DATA FOUNDED FROM style IMAGES TO SYNC..........");
      handleToFinalizeStyleSync();
    }

  }

  void handleToFinalizeStyleSync() {
    if (idsListForSync != null && idsListForSync.length > 0) {
      Map<String, Object> fiTables = SendDataHandler.getSelectedStyleIdsData(ChooseDataActivity.this, idsListForSync);
      if (fiTables != null && fiTables.length > 0) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_IN_PROCESS_STATUS);
        final Map<String, Object> inspectionData = new HashMap<String, Object>();
        final Map<String, Object> data = new HashMap<String, Object>();
        data.put("Data", new JSONObject(fiTables));
        data.put("ImageFiles", "");
        data.put("EnclosureFiles", "");
        data.put("TestReportFiles", "");
        data.put("Result", true);
        data.put("Message", "");
        data.put("MsgDetail", "");
        inspectionData.put("InspectionData", data);
        FslLog.d(TAG, " FINALIZE sync .........................................\n\n");
        SendDataHandler.sendData(ChooseDataActivity.this, inspectionData, "", new SendDataHandler.GetCallBackResult() {
        @Override
        public void onSuccess(JSONObject loginResponse) {
        if (loginResponse.optBoolean("Result")) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_SUCCESS_STATUS);
        updateStyleWhenSyncToServer(idsListForSync);

        } else {
        String msg = loginResponse.optString("Message");
        FslLog.e(TAG, FEnumerations.E_SYNC_FINALIZE_TABLE + " \n" + msg);
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        }
        }

        @Override
        public void onError(VolleyError volleyError) {
        updateSyncList(FEnumerations.E_SYNC_FINALIZE_TABLE, FEnumerations.E_SYNC_FAILED_STATUS);
        requestVolleyError(volleyError);
        }
        });
      } else {
        FslLog.d(TAG, " NO DATA FOUNDED FROM   TO SYNC..........");
      }
    }
  }

  void updateStyleWhenSyncToServer(List<String> idsListForSync) {
    StyleHandler.updateHologramSyncToServer(ChooseDataActivity.this, idsListForSync);
  }


  void handleListToSync() {

    recyclerView = (RecyclerView) findViewById(R.id.recyclerView);
    recyclerView.setHasFixedSize(true);
    recyclerView.addItemDecoration(new DividerItemDecoration(ChooseDataActivity.this,
        DividerItemDecoration.VERTICAL));

    LinearLayoutManager mLayoutManager = new LinearLayoutManager(ChooseDataActivity.this);
    recyclerView.setLayoutManager(mLayoutManager);


    statusModalList = new ArrayList<>();


  }

  //make sync status list for inspection
  void viewStatusListOfSync() {
    statusModalList.clear();
//        List<String> tableList = SyncDataHandler.getTablesToSyncList(this);
    List<String> tableList = new ArrayList<>();
    final List<SysData22Modal> statusList = SysData22Handler.getSysData22ListAccToID(this,
        FEnumerations.PKG_APP_GEN_ID, FEnumerations.PKG_APP_MAIN_ID);
    for (int i = 0; i < statusList.length; i++) {
      if (statusList.get(i).SubID.equals(FEnumerations.PKG_APP_SUB_ID)) {
        if (statusList.get(i).numVal2.equals("0")) {
          tableList = SyncDataHandler.getTablesToSyncList(this);
        } else {
          tableList = SyncDataHandler.getTablesToSyncListWithoutPkgApp(this);
        }
      }
    }
    if (tableList != null && tableList.length > 0) {
      for (int i = 0; i < tableList.length; i++) {
        StatusModal statusModal = new StatusModal();
        statusModal.tableName = tableList.get(i).trim();
        statusModalList.add(statusModal);
      }
    }
    if (syncStatusAdaptor == null) {
      syncStatusAdaptor = new SyncStatusAdaptor(ChooseDataActivity.this
          , statusModalList);
      recyclerView.setAdapter(syncStatusAdaptor);
    } else {
      syncStatusAdaptor.notifyDataSetChanged();
    }
  }

  //make sync status list  style
  void viewStatusListOfSyncOfStyleHologram() {
    statusModalList.clear();
    List<String> tableList = SyncDataHandler.getTablesToSyncStyleList(this);
    if (tableList != null && tableList.length > 0) {
      for (int i = 0; i < tableList.length; i++) {
        StatusModal statusModal = new StatusModal();
        statusModal.tableName = tableList.get(i).trim();
        statusModalList.add(statusModal);
      }
    }


    if (syncStatusAdaptor == null) {
      syncStatusAdaptor = new SyncStatusAdaptor(ChooseDataActivity.this
          , statusModalList);
      recyclerView.setAdapter(syncStatusAdaptor);
    } else {
      syncStatusAdaptor.notifyDataSetChanged();
    }
  }

  void getDataFromServerHandle() {
    GetDataHandler.getData(ChooseDataActivity.this, new GetDataHandler.GetCallBackResult() {
    @Override
    public void onSuccess(JSONObject loginResponse) {
    if (progressDataSync != null) {
    progressDataSync.setVisibility(View.GONE);
    imgDataSyncSuccess.setVisibility(View.VISIBLE);
    isDataSyncComplete = true;
    }
    // Fetch itemid count from QrpoItemdtl and show 0/total
    onDataDownloadDone(); // <-- This is correct!
    // Start image sync process here if needed, and update count as images are synced
    }

    @Override
    public void onError(VolleyError volleyError) {
    if (customProgressDialog != null && customProgressDialog.isShowing()) {
    customProgressDialog.dismiss();
    }
    Toast toast = ToastCompat.makeText(ChooseDataActivity.this, "Error syncing data", Toast.LENGTH_SHORT);
    GenUtils.safeToastShow(TAG, ChooseDataActivity.this, toast);
    }
    });
  }

  // Call this method each time an image is synced
  void updateImageSyncCount() {
    syncedImageCount++;
    if (txtImageSyncCount != null) {
      txtImageSyncCount.setText(syncedImageCount + "/" + totalImageCount);
    }
    if (syncedImageCount == totalImageCount && imgImageSyncSuccess != null) {
      imgImageSyncSuccess.setVisibility(View.VISIBLE);
      // Optionally, dismiss dialog or navigate to next page after a delay
    }
  }

  // Implement this method to get the current inspection id as needed
  String getCurrentInspectionId() {
    // Prefer idsListForSync if available, otherwise fallback to listedSyncIds
    if (idsListForSync != null && !idsListForSync.isEmpty()) {
      return idsListForSync.get(0);
    }
    if (listedSyncIds != null && !listedSyncIds.isEmpty()) {
      return listedSyncIds.get(0);
    }
    return "";
  }

  void handleChangePassword() {
    Intent intent = new Intent(ChooseDataActivity.this, ChangePassword.class);
    intent.putExtra("request", FEnumerations.REQUEST_FOR_CHANGE_PASSWORD);
    startActivity(intent);

  }


  void handleLogOut() {
    UserSession userSession = new UserSession(ChooseDataActivity.this);
    userSession.clearDataOnLogOut();
    Intent intentLogOut = new Intent(ChooseDataActivity.this, LogInActivity.class);
    intentLogOut.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK
    | Intent.FLAG_ACTIVITY_NEW_TASK);
    startActivity(intentLogOut);
  }

  @Override
  public void onBackPressed() {
    /*if (this.findViewById(R.id.mainFlatFrofileContainer).getVisibility() == View.GONE) {
            Fragment notifyFragment = getSupportFragmentManager().findFragmentById(R.id.frameContainer);

            try {
                if (notifyFragment != null) {
                    SocietyLog.d(TAG, "FragmentToRemove: " + notifyFragment);
                    getSupportFragmentManager().beginTransaction().remove(notifyFragment).commitAllowingStateLoss();
                }
            } catch (Exception e) {
                SocietyLog.d(TAG, "Exception at time remove fragment of notify");
                e.printStackTrace();
            }


            findViewById(R.id.mainFlatFrofileContainer).setVisibility(View.VISIBLE);
            hideActiobIcon();
            return;
        }*/
    super.onBackPressed();
  }

  void showActionIcon() {
    this.getSupportActionBar().setTitle("Notification");
    this.getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    final Drawable backArrow = getResources().getDrawable(R.drawable.ic_arrow_back_black_24dp);
    backArrow.setColorFilter(Color.parseColor("#FFFFFF"), PorterDuff.Mode.SRC_ATOP);
    this.getSupportActionBar().setHomeAsUpIndicator(backArrow);

  }

  void hideActiobIcon() {
    this.getSupportActionBar().setDisplayHomeAsUpEnabled(false);
    if (userSession == null)
      userSession = new UserSession(ChooseDataActivity.this);

    this.getSupportActionBar().setTitle("Welcome " + userSession.getLoginData().userProfileName);

  }


  void showProgressDialog(String message) {

    if (loadingDialog == null)
      loadingDialog = new ProgressDialog(ChooseDataActivity.this);
//        loadingDialog.setTitle("Please wait");
    loadingDialog.setMessage(message);
    if (loadingDialog != null && !loadingDialog.isShowing()) {
//            loadingDialog.show();
      GenUtils.safeProgressDialogShow(TAG, ChooseDataActivity.this, loadingDialog);
    }

  }

  void hideDialog() {
    if (loadingDialog != null && loadingDialog.isIndeterminate() && loadingDialog.isShowing()) {
      loadingDialog.dismiss();
      loadingDialog = null;
    }

  }


  @Override
  public void onClick(View view) {
    switch (view.getId()) {
      case R.id.getDataSubmit:

        handleGetdata();

        break;
      case R.id.getStyleDataSubmit:
        handleGetStyledata();
        break;
      case R.id.sendStyleSubmit:
        mViewType = FEnumerations.E_VIEW_ONLY_SEND;
        handleHologramView();
        break;
      case R.id.sendSubmit:
        mViewType = FEnumerations.E_VIEW_SEND_AND_SYNC;
        handleView();
//                startActivity(new Intent(ChooseDataActivity.this, InspectionListActivity.class));


        break;

    }
  }

  void handleGetStyledata() {
//        startActivity(new Intent(ChooseDataActivity.this, StyleList.class));

    showProgressDialog("Loading...");
    GetDataHandler.getStyleData(ChooseDataActivity.this, new GetDataHandler.GetCallBackResult() {
    @Override
    public void onSuccess(JSONObject loginResponse) {
    Toast toast = ToastCompat.makeText(ChooseDataActivity.this, "Get sync data successfully", Toast.LENGTH_SHORT);
    GenUtils.safeToastShow(TAG, ChooseDataActivity.this, toast);
    startActivity(new Intent(ChooseDataActivity.this, StyleList.class));
    hideDialog();

    }

    @Override
    public void onError(VolleyError volleyError) {
    hideDialog();
    boolean lIsErrorHandled = VolleyErrorHandler.errorHandler(ChooseDataActivity.this, volleyError);
    if (!lIsErrorHandled) {
    if (volleyError == null
    || volleyError.networkResponse == null) {
    FslLog.d(TAG, " Could Not CAUGHT EXCEPTION ...................... bcos of volleyError AND networkResponse IS NULL..");
    } else if (volleyError.networkResponse.statusCode == FStatusCode.HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR) {
    VolleyErrorHandler.handleInternalError(ChooseDataActivity.this, volleyError);
    return;
    } else if (volleyError.networkResponse.statusCode == 400) {
    VolleyErrorHandler.handleInternaBadError(ChooseDataActivity.this, volleyError);
    } else if (volleyError.networkResponse.statusCode == 404) {
    NetworkUtil.showServerErrorForStageDialog(ChooseDataActivity.this, "Bad Request");
    }

    }
    }
    });
  }

  void handleGetdata() {
    if (!chkGetInspectionData.isChecked() && !chkGetMasterData.isChecked()) {
      showCustomProgressDialog();
      getDataFromServerHandle();
    } else if (chkGetMasterData.isChecked()) {
      showCustomProgressDialog();
      getDataFromServerHandle();
    } else if (chkGetInspectionData.isChecked()) {
      showCustomProgressDialog();
      getDataFromServerHandle();
    }
  }

  void showCustomProgressDialog() {
    customProgressDialog = new Dialog(this);
    customProgressDialog.setContentView(R.layout.custom_progress_dialog);
    customProgressDialog.setCancelable(false);

    progressDataSync = customProgressDialog.findViewById(R.id.progressDataSync);
    imgDataSyncSuccess = customProgressDialog.findViewById(R.id.imgDataSyncSuccess);
    txtImageSyncCount = customProgressDialog.findViewById(R.id.txtImageSyncCount);
    imgImageSyncSuccess = customProgressDialog.findViewById(R.id.imgImageSyncSuccess);

    // Remove sync image button logic
    // Button is removed from layout, so no need to reference or set listeners

    customProgressDialog.show();
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    // The action bar home/up action should open or close the drawer.
    // ActionBarDrawerToggle will take care of this.
    switch (item.getItemId()) {
      case android.R.id.home:
        gotoBackPress();

    }

    return false;
  }

  void requestVolleyError(VolleyError volleyError) {
    boolean lIsErrorHandled = VolleyErrorHandler.errorHandler(ChooseDataActivity.this, volleyError);
    if (!lIsErrorHandled) {
      if (volleyError == null
          || volleyError.networkResponse == null) {
        FslLog.d(TAG, " Could Not CAUGHT EXCEPTION ...................... bcos of volleyError AND networkResponse IS NULL..");
      } else if (volleyError.networkResponse.statusCode == FStatusCode.HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR) {
        VolleyErrorHandler.handleInternalError(ChooseDataActivity.this, volleyError);
        return;
      }

    }
  }

  void updateStatusUI() {
    txtSyncCountSection.setText(syncDoneProcess.length + "/" + totalIdsToSync);
  }

  @Override
  protected void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    outState.putInt("type", mViewType);
    outState.putInt("mSyncViewType", mSyncViewType);
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    if (keyCode == KeyEvent.KEYCODE_BACK) {
      gotoBackPress();
    }
    return super.onKeyDown(keyCode, event);
  }

  void gotoBackPress() {
    setResult(RESULT_OK);
    finish();
  }

  // Fetch item IDs for a given inspection
  List<String> fetchItemIdsForInspection(String inspectionId) {
    return com.podetail.POItemDtlHandler.getItemIdList(this, inspectionId);
  }

  // Call this after data download is done
  void onDataDownloadDone() {
    List<String> itemIds = fetchAllItemIds();
    totalImageCount = (itemIds != null) ? itemIds.length : 0;
    syncedImageCount = 0;
    if (txtImageSyncCount != null) {
      txtImageSyncCount.setText(syncedImageCount + "/" + totalImageCount);
    }

    // Start syncing images one by one
    if (itemIds != null && !itemIds.isEmpty()) {
      syncNextImage(itemIds, 0);
    }
  }

  void syncNextImage(List<String> itemIds, int currentIndex) {
    if (currentIndex >= itemIds.length) {
      // All images synced
      if (imgImageSyncSuccess != null) {
        imgImageSyncSuccess.setVisibility(View.VISIBLE);
        txtImageSyncCount.setVisibility(View.GONE); // Hide the count when complete
      }
      new Handler().postDelayed(() -> {
      if (customProgressDialog != null && customProgressDialog.isShowing()) {
      customProgressDialog.dismiss();
      }
      startActivity(new Intent(ChooseDataActivity.this, InspectionListActivity.class));
      }, 1000);
      return;
    }

    String BE_pRowID = itemIds.get(currentIndex);
    String url = AppConfig.GET_QRPO_ITEM_IMAGE + "QRPOItemImageID=" + BE_pRowID;

    RequestQueue queue = Volley.newRequestQueue(this);
    StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
        new Response.Listener<String>() {
        @Override
        public void onResponse(String response) {
        try {
        JSONArray jsonArray = new JSONArray(response);
        if (jsonArray.length() > 0) {
        // Process each item in the array
        for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject data = jsonArray.getJSONObject(i);
        // Update QRPOItemDtl_Image table with the response data
        int updateStatus = ItemInspectionDetailHandler.updateOrInsertQRPOItemDtl_Image(ChooseDataActivity.this, data);
        FslLog.d(TAG, "QRPOItemDtl_Image update status: " + updateStatus);
        }

        //  incrementSyncCount();
        syncedImageCount++;
        if (txtImageSyncCount != null) {
        txtImageSyncCount.setText(syncedImageCount + "/" + totalImageCount);
        }
        }
        // Process next image
        syncNextImage(itemIds, currentIndex + 1);
        } catch (JSONException e) {
        FslLog.e(TAG, "Error parsing response for image " + BE_pRowID + ": " + e.getMessage());
        syncNextImage(itemIds, currentIndex + 1);
        }
        }
        },
        new Response.ErrorListener() {
        @Override
        public void onErrorResponse(VolleyError error) {
        FslLog.e(TAG, "Volley error syncing image " + BE_pRowID + ": " + error.getMessage());
        // Continue with next image even if this one failed
        syncNextImage(itemIds, currentIndex + 1);
        }
        });

    // Add the request to the RequestQueue
    queue.add(stringRequest);
  }

  // Call this after each image is synced
  void incrementSyncCount() {
    syncedImageCount++;
    if (txtImageSyncCount != null) {
      txtImageSyncCount.setText(syncedImageCount + "/" + totalImageCount);
    }
    if (syncedImageCount == totalImageCount) {
      if (imgImageSyncSuccess != null) imgImageSyncSuccess.setVisibility(View.VISIBLE);
      // Navigate to next screen after a short delay
      new Handler().postDelayed(() -> {
      if (customProgressDialog != null && customProgressDialog.isShowing()) {
      customProgressDialog.dismiss();
      }
      startActivity(new Intent(ChooseDataActivity.this, InspectionListActivity.class));
      }, 1000);
    }
  }


  List<String> fetchAllItemIds() {
    List<String> itemIds = new ArrayList<>();
    android.database.Cursor cursor = null;
    try {
      DBHelper dbHelper = new DBHelper(this);
      SQLiteDatabase database = dbHelper.getReadableDatabase();
      String query = "SELECT DISTINCT BE_pRowID FROM QRPOItemDtl_Image WHERE recEnable=1";
      cursor = database.rawQuery(query, null);
      if (cursor != null && cursor.moveToFirst()) {
        do {
          String imageName = cursor.getString(cursor.getColumnIndex("BE_pRowID"));
          if (imageName != null) {
            System.out.println( "image Name: " + imageName);
            itemIds.add(imageName);
          }
        } while (cursor.moveToNext());
      }
      if (cursor != null) cursor.close();
      database.close();
    } catch (Exception e) {
    e.printStackTrace();
    } finally {
    if (cursor != null) cursor.close();
    }
    return itemIds;
  }

}

