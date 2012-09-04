module ArchivePageExtensions
  def self.included(base)
    base.class_eval do
      alias_method :child_path_original, :child_path
      def child_path(child)
        cleaned_path = clean_path(path)
        if (NewsExtension.news_paths.any? { |i| clean_path(i) == cleaned_path } && !child.news?)
          # Page.child_path(child)
          clean_path(path + '/' + child.slug)
        else
          child_path_original(child)
        end
      end
    end
  end
end
