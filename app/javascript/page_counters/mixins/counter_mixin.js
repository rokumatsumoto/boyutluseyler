import 'bootstrap/js/dist/tooltip';

export default {
  props: {
    count: {
      type: Number,
      required: true,
    },
    localeCount: {
      type: String,
      required: true,
    },
    textPlural: {
      type: String,
      required: true,
    },
    textSingular: {
      type: String,
      required: true,
    },
  },
  mounted() {
    $('[data-toggle="tooltip"]').tooltip({
      html: true,
      // override font-size and font-weight with `counter-tooltip` css class
      // https://getbootstrap.com/docs/4.3/components/tooltips/#options
      template: '<div class="tooltip counter-tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
    });
  },
  computed: {
    counterTooltip() {
      if (this.count !== 1) return this.textPlural;

      return this.textSingular;
    },
  },
}
