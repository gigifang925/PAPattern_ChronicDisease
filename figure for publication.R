library(haven)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
library(patchwork)


############ Trajectory Plot ############

age <- rep(c("40","44","48","52","56","60"), 5)
trajectory <- c(rep("Consistently Inactive",6), rep("Consistently Medium Volume",6), rep("High to Medium Volume",6), rep("Medium to High Volume",6), 
                rep("Consistently High Volume",6))
value <- c(2.5,2.4,2.3,2.5,2.4,2.6, 13.4,12.6,12.7,13.5,14.5,15.3, 42.8,42.1,37.5,31.3,25.9,23.5, 18.5,19.5,25.1,33.0,40.7,45.3, 40.6,48.5,55.5,60.2,61.3,57.5)
df <- data.frame(trajectory, age, value)
df$age <- as.numeric(df$age)
df$trajectory <- factor(df$trajectory, levels = c("Consistently Inactive", 
                                                  "Consistently Medium Volume", 
                                                  "High to Medium Volume",
                                                  "Medium to High Volume",
                                                  "Consistently High Volume"))

lower <- c(2.5,2.3,2.3,2.4,2.4,2.6, 13.2,12.4,12.6,13.4,14.3,15.1, 42.0,41.6,37.1,30.9,25.4,22.9, 
           18.0,19.1,24.7,32.7,40.3,44.8, 39.9,48.0,55.0,59.8,60.8,56.9)
upper <- c(2.6,2.4,2.3,2.5,2.5,2.7, 13.6,12.7,12.9,13.6,14.6,15.5, 43.7,42.7,38.0,31.7,26.4,24.0,
           19.0,19.9,25.4,33.4,41.0,45.8, 41.3,49.0,55.9,60.5,61.7,58.0)
df$lower <- lower
df$upper <- upper

text <- c("6888 (9%)", "45499 (62%)", "5880 (8%)", "11022 (15%)", "4051 (6%)")
text_df <- df[df$age == max(df$age), ] 
text_df$text <- text

p <- ggplot(df, aes(x = age, y = value)) +
  geom_ribbon(aes(ymin = lower, ymax = upper, group = trajectory), fill = "grey80", alpha = 0.4, color = NA) + 
  geom_line(aes(linetype = trajectory), color = "black", size = 0.5) +
  geom_point(aes(shape = trajectory), color = "black", size = 2) +
  geom_text(data = text_df, aes(label = text), hjust = -0.1, vjust = -0.5, size = 2, show.legend = FALSE) +
  labs(x = "Age",
       y = "Physical activity volume, MET-hours/week") +
  scale_x_continuous(breaks = seq(40, 60, by = 4), limits = c(40, 64)) +
  scale_shape_manual(values = c(16, 17, 15, 18, 3)) +
  scale_linetype_manual(values = c("solid", "dotted", "dashed", "dotdash", "twodash")) +
  guides(
    shape = guide_legend(nrow = 3, byrow = TRUE),
    linetype = guide_legend(nrow = 3, byrow = TRUE)
  ) +
  theme_classic() +
  theme(
    legend.position = "bottom", 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black", size = 0.6),
    axis.ticks.length = unit(0.25, "cm"),
    text = element_text(size = 6)   # 1-column figure (5-7)
  )

ggsave(
  filename = "pa_figure2.pdf",
  plot     = p,
  width    = 88,
  height   = 100,      # 1-column figure (88, <130)
  units    = "mm",
  device   = cairo_pdf,  # good for embedded fonts & transparency
  bg       = "white"
)


############ Joint Plot ############
### major chronic disease
df1 <- structure(
  list(
    HR = c(1, 0.92, 0.84, 0.95, 0.92, 0.78, 0.88, 0.87, 0.76),
    UCI = c(1, 0.95, 0.91, 0.98, 0.94, 0.80, 0.97, 0.90, 0.78),
    LCI = c(1, 0.88, 0.77, 0.92, 0.90, 0.76, 0.81, 0.85, 0.75),
    group1 = c(rep('Tertile 1 (<10)',3), rep('Tertile 2 (10-23)',3), rep('Tertile 3 (>23)', 3)),
    group2 = rep(c('Tertile 1 (0-50%)', 'Tertile 2 (53-94%)', 'Tertile 3 (100%)'), 3)
  ),
  .Names = c('HR', 'CI_UL', 'CI_LL', 'intensity_gp', 'duration_gp'),
  row.names = c(NA, -9L),
  class = 'data.frame'
)
### T2D
df2 <- structure(
  list(
    HR = c(1, 0.84, 0.90, 0.88, 0.79, 0.62, 0.76, 0.71, 0.52),
    UCI = c(1, 0.89, 1.04, 0.93, 0.82, 0.65, 0.89, 0.75, 0.54),
    LCI = c(1, 0.78, 0.79, 0.83, 0.76, 0.59, 0.65, 0.67, 0.50),
    group1 = c(rep('Tertile 1 (<10)',3), rep('Tertile 2 (10-23)',3), rep('Tertile 3 (>23)', 3)),
    group2 = rep(c('Tertile 1 (0-50%)', 'Tertile 2 (53-94%)', 'Tertile 3 (100%)'), 3)
  ),
  .Names = c('HR', 'CI_UL', 'CI_LL', 'intensity_gp', 'duration_gp'),
  row.names = c(NA, -9L),
  class = 'data.frame'
)
### CVD
df3 <- structure(
  list(
    HR = c(1, 0.87, 0.82, 0.97, 0.84, 0.74, 0.94, 0.85, 0.70),
    UCI = c(1, 0.95, 0.99, 1.03, 0.88, 0.78, 1.13, 0.90, 0.74),
    LCI = c(1, 0.80, 0.69, 0.90, 0.80, 0.69, 0.79, 0.80, 0.67),
    group1 = c(rep('Tertile 1 (<10)',3), rep('Tertile 2 (10-23)',3), rep('Tertile 3 (>23)', 3)),
    group2 = rep(c('Tertile 1 (0-50%)', 'Tertile 2 (53-94%)', 'Tertile 3 (100%)'), 3)
  ),
  .Names = c('HR', 'CI_UL', 'CI_LL', 'intensity_gp', 'duration_gp'),
  row.names = c(NA, -9L),
  class = 'data.frame'
)
### cancer
df4 <- structure(
  list(
    HR = c(1, 0.96, 0.86, 0.98, 1.01, 0.92, 0.94, 0.97, 0.94),
    UCI = c(1, 1.01, 0.96, 1.02, 1.04, 0.95, 1.06, 1.01, 0.97),
    LCI = c(1, 0.91, 0.77, 0.94, 0.98, 0.89, 0.84, 0.93, 0.91),
    group1 = c(rep('Tertile 1 (<10)',3), rep('Tertile 2 (10-23)',3), rep('Tertile 3 (>23)', 3)),
    group2 = rep(c('Tertile 1 (0-50%)', 'Tertile 2 (53-94%)', 'Tertile 3 (100%)'), 3)
  ),
  .Names = c('HR', 'CI_UL', 'CI_LL', 'intensity_gp', 'duration_gp'),
  row.names = c(NA, -9L),
  class = 'data.frame'
)
### obesity cancer
df5 <- structure(
  list(
    HR = c(1, 0.96, 0.80, 0.95, 0.97, 0.89, 0.93, 0.91, 0.87),
    UCI = c(1, 1.02, 0.94, 1.01, 1.01, 0.94, 1.11, 0.96, 0.90),
    LCI = c(1, 0.89, 0.68, 0.90, 0.93, 0.85, 0.79, 0.86, 0.83),
    group1 = c(rep('Tertile 1 (<10)',3), rep('Tertile 2 (10-23)',3), rep('Tertile 3 (>23)', 3)),
    group2 = rep(c('Tertile 1 (0-50%)', 'Tertile 2 (53-94%)', 'Tertile 3 (100%)'), 3)
  ),
  .Names = c('HR', 'CI_UL', 'CI_LL', 'intensity_gp', 'duration_gp'),
  row.names = c(NA, -9L),
  class = 'data.frame'
)

df1$intensity_gp <- factor(df1$intensity_gp, levels = c('Tertile 1 (<10)', 'Tertile 2 (10-23)', 'Tertile 3 (>23)'))
df2$intensity_gp <- factor(df2$intensity_gp, levels = c('Tertile 1 (<10)', 'Tertile 2 (10-23)', 'Tertile 3 (>23)'))
df3$intensity_gp <- factor(df3$intensity_gp, levels = c('Tertile 1 (<10)', 'Tertile 2 (10-23)', 'Tertile 3 (>23)'))
df4$intensity_gp <- factor(df4$intensity_gp, levels = c('Tertile 1 (<10)', 'Tertile 2 (10-23)', 'Tertile 3 (>23)'))
df5$intensity_gp <- factor(df5$intensity_gp, levels = c('Tertile 1 (<10)', 'Tertile 2 (10-23)', 'Tertile 3 (>23)'))


make_panel <- function(d, panel_label) {
  # pick the reference row (HR == 1); if multiple, take the first
  ref_row <- d[d$HR == 1, , drop = FALSE][1, ]
  # all non-reference rows for HR labels
  nonref <- d[d$HR != 1, , drop = FALSE]
  
  ggplot(d, aes(x = duration_gp, y = HR, shape = duration_gp)) + 
    geom_errorbar(aes(ymax = CI_UL, ymin = CI_LL), width = 0.2) +
    geom_point(position = position_dodge(0.5), size = 1) + 
    ylab("Multivariable HR (95% CI)") +
    scale_x_discrete(name = "Cumulative average volume, MET-hours/week") + 
    ylim(0, 1.2) +
    facet_wrap(~ intensity_gp, nrow = 1L, strip.position = "bottom") +
    theme_classic() +
    theme(
      axis.text.x   = element_blank(),     # Remove x-axis text
      axis.ticks.x  = element_blank(),     # Remove x-axis ticks
      legend.position = "none",
      # Shrink axis labels
      axis.title.x = element_text(size = 8),
      axis.title.y = element_text(size = 8),
      # axis tick
      axis.text.y  = element_text(size = 7),
      # facet label
      strip.text   = element_text(size = 7)
    ) +
    # "1 (Ref)" label
    geom_text(
      data = ref_row,
      aes(x = duration_gp, y = HR + 0.05, label = "1 (Ref)"),
      inherit.aes = FALSE,
      size = 2.5,
      hjust = 0.5
    ) +
    # Horizontal reference line at HR = 1
    geom_hline(
      yintercept = 1,
      linetype   = "dashed",
      color      = "black"
    ) +
    # HR labels above the CIs for non-reference categories
    geom_text(
      data = nonref,
      aes(x = duration_gp, y = CI_UL, label = round(HR, 2)),
      inherit.aes = FALSE,
      vjust = -1,
      size  = 2.5
    ) +
    ggtitle(panel_label)
}

p1 <- make_panel(df1, "(a)")
p2 <- make_panel(df2, "(b)")
p3 <- make_panel(df3, "(c)")
p4 <- make_panel(df4, "(d)")
p5 <- make_panel(df5, "(e)")

# A temporary version of p1 with a nice legend
p1_for_legend <- ggplot(df1, aes(x = duration_gp, y = HR, shape = duration_gp)) + 
  geom_point() +
  labs(shape="% of follow-up years\nmeeting the recommended level") +
  theme_classic() +
  theme(
    legend.position   = "right",
    legend.title      = element_text(size = 10, face = "bold"),
    legend.text       = element_text(size = 8),
    legend.key.height = unit(4, "mm")
  )

legend_grob <- cowplot::get_legend(p1_for_legend)
legend_plot <- patchwork::wrap_elements(legend_grob)

combined_fig <- 
  (p1 | p2) /
  (p3 | p4) /
  (p5 | legend_plot)

ggsave(
  filename = "pa_figure1.pdf",
  plot     = combined_fig,
  width    = 180,
  height   = 240,
  units    = "mm",
  device   = "pdf",
  bg       = "white"
)

# p2 <- p1 %+% df2 + ggtitle("(b)")
# p3 <- p1 %+% df3 + ggtitle("(c)")
# p4 <- p1 %+% df4 + ggtitle("(d)")
# p5 <- p1 %+% df5 + ggtitle("(e)")


############ KM plot ############
surv <- read_sas("~/Downloads/men_surv.sas7bdat")
surv <- read_sas("~/Downloads/women_surv.sas7bdat")

df <- surv %>%
  select(int, starts_with("risk")) %>%
  filter(int != 0)

df_long <- df %>%
  pivot_longer(
    cols = starts_with("risk"),
    names_to = "time",
    names_prefix = "risk",
    values_to = "risk"
  ) %>%
  mutate(
    time = as.integer(time)*2,
    int = factor(
      int, 
      levels = c(1, 2, 3, 4), 
      labels = c("Limit to <7.5 MET-hrs/wk", "Maintain ≥7.5 MET-hrs/wk", "Maintain ≥15 MET-hrs/wk", "Maintain ≥30 MET-hrs/wk"))
  )

df_summary <- df_long %>%
  group_by(int, time) %>%
  summarise(
    mean = mean(risk, na.rm = TRUE),
    lci = quantile(risk, 0.025, na.rm = TRUE),
    uci = quantile(risk, 0.975, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(df_summary, aes(x = time, y = mean, color = int, fill = int)) +
  geom_line(size = 1.2) +
  geom_ribbon(aes(ymin = lci, ymax = uci), alpha = 0.2, color = NA) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Risk of Major Chronic Diseases Over Time by Interventions Among Women",
    x = "Follow-up years",
    y = "Cumulative incidence",
    color = "Intervention",
    fill = "Intervention"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major = element_blank(),  # Remove grid lines
    panel.grid.minor = element_blank(),
    axis.line = element_line(color="black"),
    axis.ticks = element_line(color="black", size=0.5),  # Add ticks and set their color/size
    axis.ticks.length = unit(0.2, "cm")  # Adjust tick length
  )
