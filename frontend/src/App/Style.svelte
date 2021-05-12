<style global>
  @tailwind base;
  @tailwind components;
  @tailwind utilities;

  .panel {
    @apply my-16 mx-2 md:mx-auto md:w-1/4;
    @apply border border-blue-400 rounded overflow-hidden;
    @apply shadow-lg;
    .panel-header {
      @apply py-2 px-4 text-lg border-b;
    }
  }

  .form {
    @apply my-4 w-full p-4 flex flex-col space-y-4;
  }

  .control {
    @apply px-4 py-2;
    @apply focus:outline-none focus:ring;
  }

  .button {
    @apply p-2 rounded;
    @apply focus:outline-none focus:ring;
  }

  .gray {
    @apply text-gray-900 border-gray-400;
    &.control {
      @apply hover:bg-gray-100;
    }
  }

  .blue {
    @apply text-blue-900 border-blue-400;
    &.control {
      @apply hover:bg-blue-100;
    }
    &.panel-header {
      @apply bg-blue-100;
    }
  }

  .green {
    @apply text-green-900 border-green-400;
    &.control {
      @apply hover:bg-green-100;
    }
    &.panel-header {
      @apply bg-green-100;
    }
  }

  .red {
    @apply text-red-900 border-red-400;
    &.control {
      @apply hover:bg-red-100;
    }
    &.panel-header {
      @apply bg-red-100;
    }
  }

  .item-list {
    @apply bg-gray-100 rounded-lg;

    li {
      @apply block flex px-4 py-2 border-b border-gray-400;
    }
  }

  .page-title {
    @apply text-lg font-bold;
    @apply border-yellow-700 border-l-4 pl-2;
  }

  .message {
    @apply bg-gray-100 rounded-lg;
    @apply mt-4 p-4 text-gray-700;
  }
</style>
