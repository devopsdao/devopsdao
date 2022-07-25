App = {
  loading: false,
  contracts: {},

  load: async () => {
    console.log("app loading");
    await App.loadWeb3();
    await App.loadAccount();
    await App.loadContract();
    await App.render();

    await App.renderTabs();
  },

  loadWeb3: async () => {
    // if (typeof window.ethereum !== "undefined") {
    //   console.log("MetaMask is installed!");
    // }

    // const accounts = await ethereum.request({ method: "eth_requestAccounts" });
    // const account = accounts[0];
    // console.log(account);

    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.request({ method: "eth_requestAccounts" });
      } catch (error) {
        // User denied account access...
        console.error("User denied account access");
      }
    } else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    } else {
      App.web3Provider = new Web3.providers.WebsocketProvider(
        "http://localhost:7545"
      );
    }
    web3 = new Web3(App.web3Provider);

    // if (typeof web3 !== "undefined") {
    //   App.web3Provider = web3.currentProvider;
    //   web3 = new Web3(web3.currentProvider);
    // } else {
    //   window.alert("Please connect to Metamask.");
    // }
    // Modern dapp browsers...!!!

    // if (window.ethereum) {
    //   window.web3 = new Web3(ethereum);
    //   try {
    //     // Request account access if needed
    //     await ethereum.enable();
    //     // Acccounts now exposed
    //     web3.eth.sendTransaction({
    //       /* ... */
    //     });
    //   } catch (error) {
    //     // User denied account access...
    //   }
    // }
    // // Legacy dapp browsers...
    // else if (window.web3) {
    //   App.web3Provider = web3.currentProvider;
    //   web3 = new Web3(web3.currentProvider);
    //   // Acccounts always exposed
    //   web3.eth.sendTransaction({
    //     /* ... */
    //   });
    // }
    // // Non-dapp browsers...
    // else {
    //   console.log(
    //     "Non-Ethereum browser detected. You should consider trying MetaMask!"
    //   );
    // }
  },

  loadAccount: async () => {
    // Set blockchain account
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    App.account = web3.utils.toChecksumAddress(accounts[0]);
    console.log(App.account);

    // console.log();
  },
  loadContract: async () => {
    // const FirstSC = await $.getJSON("FirstSC.json");
    const contFactory = await $.getJSON("Factory.json");
    App.contracts.contFactory = TruffleContract(contFactory);
    App.contracts.contFactory.setProvider(App.web3Provider);

    App.contFactory = await App.contracts.contFactory.deployed();
  },

  render: async () => {
    // Prevent double render
    if (App.loading) {
      return;
    }

    // Update app loading state
    App.setLoading(true);

    // Render Account
    await $("#account").html(App.account);

    // Render Tasks
    App.contFactory
      .OneEventForAll({
        // filter: { myIndexedParam: [20, 23] },
        fromBlock: 0,
        toBlock: "latest",
      })
      .on("data", async function (event) {
        console.log(event.returnValues);
        // await App.renderTasks(true, event.returnValues);
      })
      .on("error", console.error);

    // await App.renderTasks(false);

    // Update loading state
    App.setLoading(false);
  },

  setLoading: (boolean) => {
    App.loading = boolean;
    const loader = $("#loader");
    const content = $("#content");
    if (boolean) {
      loader.show();
      content.hide();
    } else {
      loader.hide();
      content.show();
    }
  },
  renderTasks: async (camefromevent, contrAdr) => {
    App.setLoading(false);
    // Load the total jobs from the blockchain
    const emptyAddress = "0x0000000000000000000000000000000000000000";

    let jobsCount;
    let jobsAddresses = [];

    jobsAddresses = await App.contFactory.allJobs();
    jobsCount = jobsAddresses.length;

    // if (camefromevent) {
    //   for (let i = 0; i < jobsAddresses.length; i++) {
    //     if (contrAdr[0] == jobsAddresses[i]) {
    //       jobsAddresses[0] = contrAdr[0];
    //       jobsCount = 1;
    //     }
    //   }

    //   // $("#exchangeList").children().remove();
    //   // $("#myProjectList").children().remove();
    //   // $("#myWorksList").children().remove();

    //   // .find(".pager-current:not(:eq(0))").remove();
    // } else {
    // }

    const $taskTemplate = $(".taskTemplate");

    for (var arr = 1; arr <= jobsCount; arr++) {
      // please fix this KASTYL arr - 1!
      let jobIndex = arr - 1;
      const jobAddress = jobsAddresses[jobIndex];
      const jobInfo = await App.contFactory.getJobInfo(jobIndex);
      const getBalance = await App.contFactory.getBalance(jobIndex);
      const balance = Web3.utils.fromWei(getBalance, "ether");
      // const balance = etherValue.toString();

      const jobTitle = jobInfo[0];
      const jobState = jobInfo[1];
      const contractAddress = jobInfo[2];
      const contractParent = jobInfo[3];
      const contractOwner = jobInfo[4];
      const createdTime = App.timeConverter(jobInfo[5].toString());
      const index = jobInfo[6];
      const description = jobInfo[7];
      const participants = jobInfo[8];
      // choosedParticipant returns 0x0000000000000000000000000000000000000000 if none choosed
      const choosedParticipant = jobInfo[9];

      let $newTaskTemplate;

      if ($("#" + contractAddress).length == 0) {
        console.log(".taskTemplate by ID not found " + contractAddress);
        $newTaskTemplate = $taskTemplate.clone();
        $newTaskTemplate.prop("id", contractAddress);
      } else {
        console.log(".taskTemplate by ID FOUND! " + contractAddress);
        $newTaskTemplate = $("#" + contractAddress);
      }

      if (participants.length != 0) {
        $newTaskTemplate
          .find("#badgeNumOfPart")
          .html(participants.length)
          .show();
      }

      $newTaskTemplate.find(".title").html(jobTitle);
      $newTaskTemplate.find(".job-content").html(description);
      $newTaskTemplate.find(".contractOwner").html(contractOwner);
      $newTaskTemplate.find(".contractAddress").html(contractAddress);
      $newTaskTemplate.find(".contractParent").html(contractParent);
      $newTaskTemplate.find(".contractPaid").html(balance);
      $newTaskTemplate.find(".contractTime").html(createdTime);
      $newTaskTemplate.find(".contractState").html(jobState);

      // Rendering by STATE scheme:
      // 1) Contractor exchange jobs view (ONLY _new_ states)
      // 1.1) Contractor participation exchange jobs (ONLY _new_ states)
      // 2) Customer jobs view  (_new_, _agreed_, _progress_, _review_, _completed_, _canceled_)
      // 3) Contractor jobs view (_agreed_, _progress_, _review_, _completed_, _canceled_)

      if (jobState == "new" && contractOwner != App.account) {
        // EXCHANGE tab
        $newTaskTemplate
          .find("button")
          .prop("name", jobAddress)
          // .prop("disabled", jobState)
          .on("click", App.buttonParticipate);

        // $("#exchangeList").prepend($newTaskTemplate);
        console.log($("#exchangeList").find("#" + contractAddress).length);

        if ($("#exchangeList").find("#" + contractAddress).length == 0) {
          $("#exchangeList").prepend($newTaskTemplate);
        } else {
          $("#exchangeList")
            .find("#" + contractAddress)
            .replaceWith($newTaskTemplate);
        }
        if ($("#myProjectList").find("#" + contractAddress).length != 0) {
          $("#myProjectList")
            .find("#" + contractAddress)
            .remove();
        }
        if ($("#myWorksList").find("#" + contractAddress).length != 0) {
          $("#myWorksList")
            .find("#" + contractAddress)
            .remove();
        }

        // Checking Contractor if he already applied for the job
        if (participants.length !== 0) {
          for (let i = 0; i < participants.length; i++) {
            if (participants[i] === App.account) {
              $newTaskTemplate.find(".midAlreadyinContr").show();
              $newTaskTemplate
                .find("#buttonParticipate")
                .prop("disabled", true);
              break;
            }
          }
        }
      } else if (contractOwner == App.account) {
        // MY PROJECT tab
        $newTaskTemplate.find("#buttonParticipate").css("display", "none");
        $("#myProjectList").prepend($newTaskTemplate);
      } else if (true) {
        $("#myWorksList").prepend($newTaskTemplate);
        $newTaskTemplate.find("#buttonParticipate").hide();
      }

      if (participants.length !== 0 && contractOwner === App.account) {
        //&& contractOwner === App.account
        if (jobState == "new") {
          for (let i = 0; i < participants.length; i++) {
            $buttonPickHimOut = $("#pickHimOut").clone();
            $buttonPickHimOut
              .find("#buttonPickHimOut")
              .prop("participant", participants[i])
              .prop("contractAddress", contractAddress)
              .prop("state", "agreed")
              .html(participants[i])
              .on("click", App.buttonChangeState);
            $buttonPickHimOut.show();
            $newTaskTemplate.find(".midParticipantlistCust").show();
            $newTaskTemplate
              .find("#participantsList")
              .append($buttonPickHimOut);
          }
        } else if (jobState == "agreed") {
          $newTaskTemplate.find("#participantChoosed").html(choosedParticipant);
          $newTaskTemplate.find(".midChoosedparticipantCust").show();
        } else if (jobState == "progress") {
          $newTaskTemplate.find(".midChoosedparticipantCust").hide();
        } else if (jobState == "review") {
          // $newTaskTemplate.find("#participantReview").html(choosedParticipant);
          $newTaskTemplate.find(".midReviewCust").show();
          $newTaskTemplate
            .find("#buttonConfirm")
            .prop("participant", choosedParticipant)
            .prop("contractAddress", contractAddress)
            .prop("state", "completed")
            .on("click", App.buttonChangeState)
            .show();
          $newTaskTemplate
            .find("#buttonReview")
            .prop("participant", choosedParticipant)
            .prop("contractAddress", contractAddress)
            .prop("state", "review")
            .html("Send to review")
            .on("click", App.buttonChangeState)
            .show();
          $newTaskTemplate.find("#buttonCancel").show();
        } else if (jobState == "completed") {
          $newTaskTemplate.find(".midReviewCust").hide();
          $newTaskTemplate.find(".participantCompletedDiv").show();
        } else if (jobState == "canceled") {
          $newTaskTemplate.find(".participantCanceledDiv").show();
        }
      }

      if (choosedParticipant.toString() != emptyAddress) {
        $newTaskTemplate.find(".midParticipantlistCust").hide();
        $newTaskTemplate.find(".midAlreadyinContr").hide();
        if (choosedParticipant == App.account) {
          if (jobState == "agreed") {
            $newTaskTemplate
              .find("#buttonConfirm")
              .prop("participant", choosedParticipant)
              .prop("contractAddress", contractAddress)
              .prop("state", "progress")
              .on("click", App.buttonChangeState)
              .show();
            $newTaskTemplate.find(".midCongratulationCont").show();
          } else if (jobState == "progress") {
            $newTaskTemplate.find("#buttonConfirm").hide();
            $newTaskTemplate.find(".midCongratulationCont").hide();
            $newTaskTemplate
              .find("#buttonReview")
              .prop("participant", choosedParticipant)
              .prop("contractAddress", contractAddress)
              .prop("state", "review")
              .on("click", App.buttonChangeState)
              .show();
            $newTaskTemplate.find(".midInprogressCont").show();
          } else if (jobState == "review") {
            $newTaskTemplate.find("#buttonReview").hide();
            $newTaskTemplate.find(".midInprogressCont").hide();
            $newTaskTemplate.find(".midReviewCont").show();
          } else if (jobState == "completed") {
            $newTaskTemplate.find(".midReviewCont").hide();
            $newTaskTemplate
              .find("#buttonWithdraw")
              .prop("participant", choosedParticipant)
              .prop("contractAddress", contractAddress)
              .prop("state", "review")
              .on("click", App.buttonWithdraw)
              .show();
          }
        }
      }

      // Show the task
      $newTaskTemplate.show();
    }
  },
  createTask: async () => {
    App.setLoading(true);
    const title = $("#jobTitle").val();
    const text = $("#jobText").val();
    const price = $("#jobPrice").val();
    await App.contFactory.createJobContract(title, text, { from: App.account });
    // await App.contFactory.create(title, price, { from: App.account });
    // window.location.reload();
  },
  buttonChangeState: async (e) => {
    // Review comes from Contractor
    App.setLoading(true);
    const contractAddress = e.target.contractAddress;
    const choosedContractor = e.target.participant;
    const state = e.target.state;
    await App.contFactory.jobStateChange(
      contractAddress,
      choosedContractor,
      state,
      {
        from: App.account,
      }
    );
    // window.location.reload();
  },
  // buttonConfirm: async (e) => {
  //   // Confirm comes from Customer
  //   App.setLoading(true);
  //   const contractAddress = e.target.contractAddress;
  //   const choosedContractor = e.target.participant;
  //   await App.contFactory.jobConfimation(contractAddress, choosedContractor, {
  //     from: App.account,
  //   });
  //   window.location.reload();
  // },
  buttonPickHimOut: async (e) => {
    // Pick out comes from Contractor
    App.setLoading(true);
    const contractAddress = e.target.contractAddress;
    const participantAddress = e.target.participant;
    await App.contFactory.jobParticiantAgreed(
      contractAddress,
      participantAddress,
      {
        from: App.account,
      }
    );
    // window.location.reload();
  },
  buttonParticipate: async (e) => {
    // Confirm comes from Customer
    App.setLoading(true);
    const contractAddress = e.target.name;
    await App.contFactory.jobParticipate(contractAddress, {
      from: App.account,
    });
    // window.location.reload();
  },
  renderTabs: async () => {
    // tabs buttons
    const $buttonsGroup = $(".buttons-group")
      .find("button")
      .on("click", App.tabSwitcher);
  },
  tabSwitcher: async (e) => {
    const tabsContent = $(".tab-content");
    const tabToShow = $("#content-" + e.target.id);
    tabsContent.css("display", "none");
    tabToShow.css("display", "block");
  },
  timeConverter: function (UNIX_timestamp) {
    var a = new Date(UNIX_timestamp * 1000);
    var months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    var year = a.getFullYear();
    var month = months[a.getMonth()];
    var date = a.getDate();
    var hour = a.getHours();
    var min = a.getMinutes();
    var sec = a.getSeconds();
    var time =
      date + " " + month + " " + year + " " + hour + ":" + min + ":" + sec;
    return time;
  },
};

$(() => {
  $(window).load(() => {
    App.load();
  });
});
