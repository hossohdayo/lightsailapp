const HelloVueApp = Vue.createApp({
  data() {
    return {
      team_name: '',
      number: '',
      results: []
    }
  },
  methods: {
    onSubmit: function(event) {
      let params = {
        team_name: this.team_name,
        number: this.number
      }
      const query_params = new URLSearchParams(params)
      fetch('https://api.hossohdayo.com/player?' + query_params, {
        method: 'GET',
      })
      .then(response => response.json())
      .then(data => this.results = data)
      .catch(error => console.log(error))
      // console.log(event)
    }
  },
  mounted() {
      console.log("mounted")
  }
})