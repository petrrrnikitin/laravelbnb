<template>
    <div>
        <h6 class="text-uppercase text-secondary font-weight-bolder">
            Check Availability
            <span v-if="noAvailability" class="text-danger">(NOT AVAILABLE)</span>
            <span v-if="hasAvailability" class="text-success">(AVAILABLE)</span>
        </h6>

        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="from">From</label>
                <input id="from" v-model="from"
                       @keyup.enter="check"
                       :class="[{'is-invalid': this.errorFor('from')}]"
                       name="from"
                       type="text"
                       class="form-control form-control-sm" placeholder="Start date">
                <div class="invalid-feedback" v-for="(error,index) in this.errorFor('from')" :key="`from${index}`">
                    {{ error }}
                </div>
            </div>
            <div class="form-group col-md-6">
                <label for="to">To</label>
                <input id="to" v-model="to"
                       @keyup.enter="check"
                       :class="[{'is-invalid': this.errorFor('to')}]"
                       name="to"
                       type="text"
                       class="form-control form-control-sm" placeholder="End date">
                <div class="invalid-feedback" v-for="(error,index) in this.errorFor('to')" :key="`to${index}`">
                    {{ error }}
                </div>
            </div>
        </div>
        <button class="btn btn-secondary btn-block" @click="check" :disabled="loading">Check!</button>
    </div>
</template>

<script>
export default {
    name: "Availability",
    props: {
        bookableId: String
    },
    data() {
        return {
            from: null,
            to: null,
            loading: false,
            status: null,
            errors: null
        }
    },
    methods: {
        check() {
            this.loading = true;
            this.errors = null;

            axios.get(`/api/bookable/${this.bookableId}/availability?from=${this.from}&to=${this.to}`)
                .then(response => {
                    this.status = response.status;
                })
                .catch(error => {
                    if (422 === error.response.status) {
                        this.errors = error.response.data.errors;
                    }
                    this.status = error.response.status;
                })
                .then(() => this.loading = false)
        },
        errorFor(field) {
            return this.hasErrors && this.errors[field] ? this.errors[field] : null;
        }
    },
    computed: {
        hasErrors() {
            return 422 === this.status && this.errors !== null;
        },
        hasAvailability() {
            return 200 === this.status;
        },
        noAvailability() {
            return 404 === this.status;
        }
    }
}
</script>

<style lang="scss" scoped>
label {
    font-size: 0.7em;
    text-transform: uppercase;
    color: gray;
    font-weight: bolder;
}

.is-invalid {
    border-color: #b22222;
    background-image: none;
}

.invalid-feedback {
    color: #b22222;
}
</style>
