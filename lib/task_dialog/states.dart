
import 'package:flutter/cupertino.dart';

Map<String, dynamic> dialogStates = {
  // ******* TASKS NEW ********* //
  'empty' : {
    'name' : 'empty',
    'mainButtonName' : '',
    'secondButtonName' : '',
    'labelMessage' : '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      // '1' : 1,
      // '2' : 2,
      // '3' : 3,
      // '4' : 4,
    },
  },
  'tasks-new-logged' : {
    'name' : 'tasks-new-logged',
    'mainButtonName' : 'Participate',
    'secondButtonName' : '',
    'labelMessage' : 'Why you are the best Performer?',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1
    },
  },
  'last-activities' : {
    'name' : 'last-activities',
    'mainButtonName' : '',
    'secondButtonName' : '',
    'labelMessage' : '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1
    },
  },
  'tasks-new-not-logged' : {
    'name' : 'tasks-new-not-logged',
    'mainButtonName': '',
    'secondButtonName' : '',
    'selectButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'selectLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1
    },
  },
  // ******* CUSTOMER ********* //
  'customer-new' : {
    'name' : 'customer-new',
    'mainButtonName': '',
    'secondButtonName' : '',
    'selectButtonName' : 'Select performer',
    'labelMessage': '',
    'secondLabelMessage': '',
    'selectLabelMessage': 'Why you have selected this Performer?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'select' : 3,
    },
  },
  'customer-agreed' : {
    'name' : 'customer-agreed',
    'mainButtonName': '',
    'secondButtonName' : 'Request audit',
    'labelMessage': '',
    'secondLabelMessage': 'Why are you requesting for audit?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'widgets.chat' : 3,
    },
  },
  'customer-progress' : {
    'name' : 'customer-progress',
    'mainButtonName': '',
    'secondButtonName' : 'Request audit',
    'labelMessage': '',
    'secondLabelMessage': 'Why are you requesting for audit?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'widgets.chat' : 3,
    },
  },

  'customer-review' : {
    'name' : 'customer-review',
    'mainButtonName': 'Sign Review',
    'secondButtonName' : 'Request audit',
    'labelMessage': 'Write your request for review to the Performer',
    'secondLabelMessage': 'Why are you requesting for audit?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'widgets.chat' : 3,
    },
  },
  'customer-completed' : {
    'name' : 'customer-completed',
    'mainButtonName': 'Rate',
    'secondButtonName' : '',
    'labelMessage': 'Write your thanks message to the Customer',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'customer-canceled' : {
    'name' : 'customer-canceled',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'customer-audit-requested' : {
    'name' : 'customer-audit-requested',
    'mainButtonName': '',
    'secondButtonName' : '',
    'selectButtonName' : 'Select auditor',
    'labelMessage': '',
    'secondLabelMessage': '',
    'selectLabelMessage': 'Why you have selected this Auditor?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'select' : 3,
      'widgets.chat' : 4,
    },
  },
  'customer-audit-performing' : {
    'name' : 'customer-audit-performing',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'widgets.chat' : 3,
    },
  },
  // 'customer-audit-finished' : {
  // 'name' : 'customer-audit-finished',
  //   'mainButtonName': '',
  //   'secondButtonName' : '',
  //   'labelMessage': '',
  //   'secondLabelMessage': '',
  //   'pages' : {
  //     'topup': 0,
  //     'main': 1,
  //     'description' : 2,
  //     'chat' : 3,
  //   },
  // },

  // ******* PERFORMER ********* //
  'performer-new' : {
    'name' : 'performer-new',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
    },
  },
  'performer-agreed' : {
    'name' : 'performer-agreed',
    'mainButtonName': 'Start the task',
    'secondButtonName' : '',
    'labelMessage': 'Summarize your implementation plans',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'performer-progress' : {
    'name' : 'performer-progress',
    'mainButtonName': 'Review',
    'secondButtonName' : '',
    'labelMessage': 'Tell about your work to review',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'performer-review' : {
    'name' : 'performer-review',
    'mainButtonName': 'Check merge',
    'secondButtonName' : 'Request audit',
    'labelMessage': '',
    'secondLabelMessage': 'Why are you requesting for audit?',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'performer-completed' : {
    'name' : 'performer-completed',
    'mainButtonName': 'Rate',
    'secondButtonName' : '',
    'labelMessage': 'Write your thanks message to the Customer',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'performer-canceled' : {
    'name' : 'performer-canceled',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'performer-audit-requested' : {
    'name' : 'performer-audit-requested',
    'mainButtonName': '',
    'secondButtonName' : '',
    'selectButtonName' : 'Select auditor',
    'labelMessage': '',
    'secondLabelMessage': '',
    'selectLabelMessage': 'Why you have selected this Auditor?',
    'pages' : {
      'main': 0,
      'description' : 1,
      'select' : 2,
      'widgets.chat' : 3,
    },
  },
  'performer-audit-performing' : {
    'name' : 'performer-audit-performing',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  // 'performer-audit-finished' : {
  // 'name' : 'performer-audit-finished',
  //   'mainButtonName': '',
  //   'secondButtonName' : '',
  //   'labelMessage': '',
  //   'secondLabelMessage': '',
  //   'pages' : {
  //     'main': 0,
  //     'description' : 1,
  //     'chat' : 2,
  //   },
  // },


  // ******* AUDITOR ********* //
  'auditor-new' : {
    'name' : 'auditor-new',
    'mainButtonName': 'Take audit',
    'secondButtonName' : '',
    'labelMessage': 'Tell about your audit experience',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'auditor-applied' : {
    'name' : 'auditor-applied',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'auditor-performing' : {
    'name' : 'auditor-performing',
    'mainButtonName': 'Take decision',
    'secondButtonName' : '',
    'labelMessage': 'Conclude your Audit decision reasoning',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
  'auditor-finished' : {
    'name' : 'auditor-finished',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'widgets.chat' : 2,
    },
  },
};
