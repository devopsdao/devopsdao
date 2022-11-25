
import 'package:flutter/cupertino.dart';

class DialogProcess extends ChangeNotifier {

}


Map<String, dynamic> dialogStates = {
  // ******* TASKS NEW ********* //
  'tasks-new' : {
    'name' : 'tasks-new',
    'mainButtonName' : 'Participate',
    'secondButtonName' : '',
    'labelMessage' : 'Why you are the best Performer?',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1
    },
  },
  // ******* CUSTOMER ********* //
  'customer-new' : {
    'name' : 'customer-new',
    'mainButtonName': 'Select performer',
    'secondButtonName' : '',
    'labelMessage': 'Why you have selected this Performer?',
    'secondLabelMessage': '',
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
    'secondLabelMessage': 'Why are you requesting an auditor?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'chat' : 3,
    },
  },
  'customer-progress' : {
    'name' : 'customer-progress',
    'mainButtonName': '',
    'secondButtonName' : 'Request audit',
    'labelMessage': '',
    'secondLabelMessage': 'Why are you requesting an auditor?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'chat' : 3,
    },
  },

  'customer-review' : {
    'name' : 'customer-review',
    'mainButtonName': 'Sign Review',
    'secondButtonName' : 'Request audit',
    'labelMessage': 'Write your request for review to the Customer',
    'secondLabelMessage': 'Why are you requesting an auditor?',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'chat' : 3,
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
      'chat' : 2,
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
      'chat' : 2,
    },
  },
  'customer-audit-requested' : {
    'name' : 'customer-audit-requested',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'topup': 0,
      'main': 1,
      'description' : 2,
      'chat' : 3,
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
      'chat' : 3,
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
  'performer-agreed' : {
    'name' : 'performer-agreed',
    'mainButtonName': 'Start the task',
    'secondButtonName' : '',
    'labelMessage': 'Summarize your implementation plans',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'chat' : 2,
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
      'chat' : 2,
    },
  },
  'performer-review' : {
    'name' : 'performer-review',
    'mainButtonName': '',
    'secondButtonName' : 'Request audit',
    'labelMessage': '',
    'secondLabelMessage': 'Why are you requesting an auditor?',
    'pages' : {
      'main': 0,
      'description' : 1,
      'chat' : 2,
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
      'chat' : 2,
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
      'chat' : 2,
    },
  },
  'performer-audit-requested' : {
    'name' : 'performer-audit-requested',
    'mainButtonName': '',
    'secondButtonName' : '',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'chat' : 2,
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
      'chat' : 2,
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
  'auditor-requested' : {
    'name' : 'auditor-requested',
    'mainButtonName': 'Take audit',
    'secondButtonName' : 'Tell about your audit experience',
    'labelMessage': '',
    'secondLabelMessage': '',
    'pages' : {
      'main': 0,
      'description' : 1,
      'chat' : 2,
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
      'chat' : 2,
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
      'chat' : 2,
    },
  },
};
