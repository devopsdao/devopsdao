App = {
  loading: false,
  contracts: {},

  load: async () => {
    console.log("app loading");
    await App.loadWeb3();
    await App.loadAccount();
    await App.loadContract();
    await App.render();
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
      App.web3Provider = new Web3.providers.HttpProvider(
        "http://localhost:7545"
      );
    }
    web3 = new Web3(App.web3Provider);
  },

  loadAccount: async () => {
    // Set blockchain account
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    App.account = accounts[0];
    console.log(App.account);
  },
  loadContract: async () => {
    const FirstSC = await $.getJSON("FirstSC.json");
    // const FirstSC = await $.getJSON("Factory.json");
    App.contracts.FirstSC = TruffleContract(FirstSC);
    App.contracts.FirstSC.setProvider(App.web3Provider);

    App.FirstSC = await App.contracts.FirstSC.deployed();
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
    await App.renderTasks();

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
  renderTasks: async () => {
    // Load the total task count from the blockchain
    let taskPrepCount = await App.FirstSC.taskCount();
    const taskCount = taskPrepCount.words[0];

    const $taskTemplate = $(".taskTemplate");

    for (var i = 1; i <= taskCount; i++) {
      // Fetch the task data from the blockchain
      const task = await App.FirstSC.tasks(i);

      const taskId = task[0].toNumber();
      const taskContent = task[1];
      const taskCompleted = task[2];
      const contractOwner = task[3];
      const contractAddress = task[4];
      const contractPrice = task[5].toNumber();
      const balance = task[6].toNumber();

      // Create the html for the task
      const $newTaskTemplate = $taskTemplate.clone();
      $newTaskTemplate.find(".content").html(taskContent);
      $newTaskTemplate
        .find("input")
        .prop("name", taskId)
        .prop("checked", taskCompleted)
        .on("click", App.buttonCompleted);
      $newTaskTemplate.find(".contractOwner").html(contractOwner);
      $newTaskTemplate.find(".contractAddress").html(contractAddress);
      $newTaskTemplate.find(".contractPrice").html(balance);

      // Put the task in the correct list
      if (taskCompleted) {
        $("#completedTaskList").append($newTaskTemplate);
      } else {
        $("#taskList").append($newTaskTemplate);
      }

      // Show the task
      $newTaskTemplate.show();
    }
  },
  createTask: async () => {
    App.setLoading(true);
    const content = $("#newTask").val();
    const price = $("#jobPrice").val();
    await App.FirstSC.createTask(content, price, { from: App.account });
    window.location.reload();
  },
  buttonCompleted: async (e) => {
    App.setLoading(true);
    const taskId = e.target.name;
    await App.FirstSC.buttonCompleted(taskId, { from: App.account });
    window.location.reload();
  },
};

$(() => {
  $(window).load(() => {
    App.load();
  });
});
